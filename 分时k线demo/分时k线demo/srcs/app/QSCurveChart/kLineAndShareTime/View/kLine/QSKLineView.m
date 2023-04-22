//
//  QSKLineView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/5.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSKLineView.h"

// VMs
#import "QSTrendViewModel.h"

// itools
#import "QSCurveChartGlobalVariable.h"
#import "QSConstant.h"

// Views
#import "QSMainKLineView.h"
#import "QSTrackingCrossView.h"
#import "QSTechView.h"

@interface QSKLineView()<UIScrollViewDelegate, QSMainKLineViewDelegate, QSTechViewDelegate>

@property (nonatomic, strong) UIScrollView *panScrollView;
@property (nonatomic, strong) QSMainKLineView *mainKlineView; //主k线
@property (nonatomic, strong) QSTechView *techView; //指标view
@property (nonatomic, strong) QSTrackingCrossView *trackingCrossView;//十字光标

@property (nonatomic, strong) NSTimer *longPressTimer;//长按手势计时器
@property (nonatomic, assign) NSInteger showStartIndex;//数据开始显示的位置
@property (nonatomic, assign) NSInteger showCount;//数据的长度
@property (nonatomic, assign) QSCurveTechType techType; //当前需要实现的指标类型
@property (nonatomic, assign) CGFloat previousScrollViewOffsetX;//记录ScrollView上一次次滑动的偏移量

@property (nonatomic, copy) NSArray *testTechArr;
@property (nonatomic, assign) NSInteger testIndex;

@property (nonatomic, strong) QSTrendViewModel *viewModel;

@end

@implementation QSKLineView

- (void)dealloc {
    if (_viewModel) {
        [_viewModel removeObserver:self forKeyPath:@"techsDataModelDic" context:nil];
    }
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendViewModel *)viewModel {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.viewModel = viewModel;
        self.showCount = frame.size.width / ([QSCurveChartGlobalVariable kLineGap] + [QSCurveChartGlobalVariable kLineWidth]);
        // 指标类型默认时成交量
        self.techType = QSCurveTechType_KDJ;
        [self makePanScrollView];
        [self makeMainKlineView];
        [self makeTechView];
        [self registerEvent];
        [self setupSwitchTechBtn];
    }
    return self;;
}

#pragma mark - Private Methods

- (void)registerEvent {
    [self.viewModel addObserver:self forKeyPath:@"techsDataModelDic" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateScrollViewContenSize {
    NSArray *allKLineDatas = [self.viewModel getMainKLineDatas];
    if (!allKLineDatas || allKLineDatas.count == 0) {
        return;
    }
    CGFloat scrollViewWidth = self.panScrollView.frame.size.width;
    CGFloat scrollViewContentWidth = ([QSCurveChartGlobalVariable kLineGap] + [QSCurveChartGlobalVariable kLineWidth]) * allKLineDatas.count;
    if (scrollViewContentWidth < scrollViewWidth) {
        scrollViewContentWidth = scrollViewWidth + 1;
    }
    self.panScrollView.contentSize = CGSizeMake(scrollViewContentWidth, self.panScrollView.frame.size.height);
}

- (void)updateKLineViewAndTechViewData {
    //刷新
    if (self.techType == QSCurveTechType_Volume) {
        self.techView.needDrawTechModels = [self.viewModel getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:QSCurveTechType_Volume];
    } else if (self.techType == QSCurveTechType_KDJ) {
        self.techView.needDrawTechModels = [self.viewModel getKDJDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:QSCurveTechType_KDJ];
    } else if (self.techType == QSCurveTechType_BOLL) {
        self.techView.needDrawTechModels = [self.viewModel getBOLLDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        self.techView.needDrawKlineModels = [self.viewModel getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:QSCurveTechType_BOLL];
    } else if (self.techType == QSCurveTechType_MACD) {
        self.techView.needDrawTechModels = [self.viewModel getMACDDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:QSCurveTechType_MACD];
    }
}

- (void)setupSwitchTechBtn {
    self.testTechArr = [NSArray arrayWithObjects:@(QSCurveTechType_Volume),@(QSCurveTechType_KDJ),@(QSCurveTechType_BOLL), @(QSCurveTechType_MACD), nil];
    self.testIndex = 0;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height  - 200, 100, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"点我点我😊" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:btn];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)contex {
    [self updateScrollViewContenSize];
    CGFloat contentOffsetXMax = self.panScrollView.contentSize.width - CGRectGetWidth(self.panScrollView.frame);
    self.panScrollView.contentOffset = CGPointMake(contentOffsetXMax , 0);
}

#pragma mark - Events Response

- (void)testAction:(UIButton *)sender {
    
    [self.viewModel pritfTestLog]; /// test tianmaotao
    
    
    self.testIndex++;
    if (self.testIndex > (self.testTechArr.count - 1)) {
        self.testIndex = 0;
    }
    NSNumber *num = self.testTechArr[self.testIndex];
    NSInteger index = [num integerValue];
    if (index == QSCurveTechType_Volume) {
        self.techType = QSCurveTechType_Volume;
    } else if (index == QSCurveTechType_KDJ) {
        self.techType = QSCurveTechType_KDJ;
    } else if (index == QSCurveTechType_BOLL) {
        self.techType = QSCurveTechType_BOLL;
    } else if (index == QSCurveTechType_MACD){
        self.techType = QSCurveTechType_MACD;
    }
    
    [self updateKLineViewAndTechViewData];
}

- (void)pinchMethod:(UIPinchGestureRecognizer *)pinch {
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;

    CGFloat oldKLineWidth = [QSCurveChartGlobalVariable kLineWidth];
    CGFloat newKlineWidth = oldKLineWidth * (difValue > 0 ? (1 + QSCurveChartKLineScaleFactor) : (1 - QSCurveChartKLineScaleFactor));
    if (newKlineWidth >= QSCurveChartKLineMaxWidth) {
        return;
    }

    if(ABS(difValue) > QSCurveChartKLineScaleBound) {
        [QSCurveChartGlobalVariable setkLineWith:newKlineWidth];
        oldScale = pinch.scale;
        //更新显示蜡烛的数量
        NSInteger oldShowCount = self.showCount;
        self.showCount = self.panScrollView.frame.size.width / ([QSCurveChartGlobalVariable kLineGap] + [QSCurveChartGlobalVariable kLineWidth]);
        NSInteger changeShowCount = oldShowCount - self.showCount;
        self.showStartIndex = self.showStartIndex + changeShowCount / 2;

        [self updateScrollViewContenSize];

        //
        
        CGFloat newScrollViewContentOffset = self.mainKlineView.frame.origin.x * (difValue > 0 ? (1 + QSCurveChartKLineScaleFactor) : (1 - QSCurveChartKLineScaleFactor));
        self.panScrollView.contentOffset = CGPointMake(newScrollViewContentOffset, 0);
    }
}

- (void)longPressMethod:(UILongPressGestureRecognizer *)longPress{
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        [self makeTrackingCrossView];
        
        CGPoint location = [longPress locationInView:self.mainKlineView];
        //暂停滑动
        self.panScrollView.scrollEnabled = NO;
        self.trackingCrossView.hidden = NO;
        if (self.longPressTimer) {
            //上一次计时操作无效，先移除掉
            [self.longPressTimer invalidate];
            self.longPressTimer = nil;
        }
        
        [self.mainKlineView longPressOrMovingAtPoint:location];
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded) {
        //隐藏十字光标
        self.panScrollView.scrollEnabled = YES;
        
        self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hiddenTrackingCrossView:) userInfo:nil repeats:NO];
    }
}

- (void)tapMethod:(UITapGestureRecognizer *)tapGesture {
    
}

- (void)hiddenTrackingCrossView:(NSTimer *)timer {
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
    self.trackingCrossView.hidden = YES;
    
    //恢复主k线和指标的详情数据（显示原始详情数据）
    [self.mainKlineView reDrawShowViewWithIndex:-1];
}

#pragma mark -  QSMainKLineViewDelegate

- (void)kLineMainViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressPrice:(CGFloat)price {
    [self.techView reDrawTechShowViewWithIndex:index];
    self.viewModel.trackingCrossVM.showValue = price;
    CGFloat trackingCrossViewPointX = longPressPosition.x;
    if (trackingCrossViewPointX < 0) {
        trackingCrossViewPointX = 0;
    }
    if (trackingCrossViewPointX > self.mainKlineView.frame.size.width) {
        trackingCrossViewPointX = self.mainKlineView.frame.size.width;
    }
    CGFloat trackingCrossViewPointY = longPressPosition.y;
    if (trackingCrossViewPointY < 0) {
        trackingCrossViewPointY = 0;
    }
    self.viewModel.trackingCrossVM.crossPoint = CGPointMake(trackingCrossViewPointX, trackingCrossViewPointY);
    [self.trackingCrossView updateTrackingCrossView];
}

#pragma mark - QSTechViewDelegate
- (void)techViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressValue:(CGFloat)longPressValue {
    [self.mainKlineView reDrawShowViewWithIndex:index];
    self.viewModel.trackingCrossVM.showValue = longPressValue;
    CGFloat trackingCrossViewPointX = longPressPosition.x;
    if (trackingCrossViewPointX < 0) {
        trackingCrossViewPointX = 0;
    }
    if (trackingCrossViewPointX > self.techView.frame.size.width) {
        trackingCrossViewPointX = self.techView.frame.size.width;
    }
    CGFloat trackingCrossViewPointY = longPressPosition.y+ self.techView.frame.origin.y;
    if (trackingCrossViewPointY > (self.techView.frame.size.height + self.techView.frame.origin.y) ) {
        trackingCrossViewPointY = self.techView.frame.size.height + self.techView.frame.origin.y;
    }
    self.viewModel.trackingCrossVM.crossPoint = CGPointMake(trackingCrossViewPointX, trackingCrossViewPointY);;
    [self.trackingCrossView updateTrackingCrossView];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    //================================================================================
    // 左右滑动逻辑说明：主k线view的宽度略大于整个k线视图的宽度，当左右滑动到主k线的边界点时，去刷新显示在主k线视图上的数据，并调整主k线视图的位置
    //================================================================================
    CGPoint scrollViewOffset = scrollView.contentOffset;
    CGFloat difValue = scrollViewOffset.x - self.previousScrollViewOffsetX;
    
    // 刷新主k线和指标view的位置
    self.mainKlineView.frame = CGRectMake(scrollViewOffset.x, self.mainKlineView.frame.origin.y, self.mainKlineView.frame.size.width, self.mainKlineView.frame.size.height);
    
    // 刷新主k线和指标view的位置
    self.techView.frame = CGRectMake(scrollViewOffset.x, self.techView.frame.origin.y, self.techView.frame.size.width, self.techView.frame.size.height);
    
    if (ABS(difValue) < ([QSCurveChartGlobalVariable kLineGap] + [QSCurveChartGlobalVariable kLineWidth])) {
        return;
    }
    
    if (scrollViewOffset.x > 0 || scrollViewOffset.x < (self.panScrollView.contentSize.width - self.mainKlineView.frame.size.width)) {
        //计算显示数据的起始位置,这个地方存在误差，先不处理，后面再处理
        self.showStartIndex = scrollViewOffset.x / ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
        
        //刷新主k线的数据
        [self.viewModel drawKLineWithRange:NSMakeRange(self.showStartIndex, self.showCount) direction:QSRangeDirectionRight];
        
        //绘制指标
        [self updateKLineViewAndTechViewData];
        
        self.previousScrollViewOffsetX = scrollViewOffset.x;
    }
}

#pragma mark - Getter

- (void)makePanScrollView {
    if (!_panScrollView) {
        _panScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _panScrollView.showsVerticalScrollIndicator = NO;
        _panScrollView.showsHorizontalScrollIndicator = NO;
        _panScrollView.delegate = self;
        [self addSubview:_panScrollView];
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchMethod:)];
        [_panScrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMethod:)];
        [_panScrollView addGestureRecognizer:longPressGesture];
        
        //点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
        tapGesture.numberOfTapsRequired = 1;
        [_panScrollView addGestureRecognizer:tapGesture];
    }
}

- (void)makeMainKlineView {
    if (!_mainKlineView) {
        _mainKlineView = [[QSMainKLineView alloc] initWithViewModel:self.viewModel.kLineVM];
        _mainKlineView.delegate = self;
        _mainKlineView.frame = CGRectMake(0, 0, self.frame.size.width, 200);
        [self.panScrollView addSubview:_mainKlineView];
    }
}

- (void)makeTrackingCrossView {
    if (!_trackingCrossView) {
        self.viewModel.trackingCrossVM.dateRect = CGRectMake(0, self.mainKlineView.frame.origin.y + self.mainKlineView.frame.size.height, self.mainKlineView.frame.size.width, 20);
        _trackingCrossView = [[QSTrackingCrossView alloc] initWithFrame:self.bounds];
        _trackingCrossView.hidden = YES;
        [_trackingCrossView bindVM:self.viewModel.trackingCrossVM];
        [self addSubview:_trackingCrossView];
    }
}

- (void)makeTechView {
    if (!_techView) {
        CGFloat techViewWidth = self.panScrollView.frame.size.width;
        CGFloat techViewHeight = 150;
        _techView = [[QSTechView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 200  + 50, techViewWidth, techViewHeight)];
        _techView.delegate = self;
        [self.panScrollView addSubview:_techView];
    }
}

@end
