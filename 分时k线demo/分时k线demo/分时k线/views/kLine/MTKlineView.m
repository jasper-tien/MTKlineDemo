//
//  MTKlineView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/10.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTKlineView.h"
#import "MTMianKLineView.h"
#import "MTTechView.h"
#import "UIColor+CurveChart.h"
#import "MTCurveChartGlobalVariable.h"

@interface MTKlineView ()<MTMianKLineViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
//主k线
@property (nonatomic, strong) MTMianKLineView *mainKlineView;
//指标view
@property (nonatomic, strong) MTTechView *techView;
//当前需要实现的指标类型
@property (nonatomic, assign) SJCurveTechType techType;
//记录ScrollView上一次次滑动的偏移量
@property (nonatomic, assign) CGFloat previousScrollViewOffsetX;
//数据开始显示的位置
@property (nonatomic, assign) NSInteger showStartIndex;
//数据的长度
@property (nonatomic, assign) NSInteger showCount;

@property (nonatomic, copy) NSArray *testTechArr;
@property (nonatomic, assign) NSInteger testIndex;
@end

@implementation MTKlineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor assistBackgroundColor];
        self.previousScrollViewOffsetX = 0;
        self.showCount = self.scrollView.frame.size.width / ([MTCurveChartGlobalVariable kLineGap] + [MTCurveChartGlobalVariable kLineWidth]);
        self.techType = SJCurveTechType_Volume;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 5 + 50, 100, 30)];
        [btn setTitle:@"切换指标" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@", self.scrollView);
        self.testTechArr = [NSArray arrayWithObjects:@(SJCurveTechType_Volume),@(SJCurveTechType_KDJ),@(SJCurveTechType_BOLL), nil];
        self.testIndex = 0;
        [self addSubview:btn];
    }

    
    return self;
}

- (void)testAction:(UIButton *)sender {
    self.testIndex++;
    if (self.testIndex > (self.testTechArr.count - 1)) {
        self.testIndex = 0;
    }
    NSNumber *num = self.testTechArr[self.testIndex];
    NSInteger index = [num integerValue];
    if (index == SJCurveTechType_Volume) {
        self.techType = SJCurveTechType_Volume;
    } else if (index == SJCurveTechType_KDJ) {
        self.techType = SJCurveTechType_KDJ;
    } else if (index == SJCurveTechType_BOLL) {
        self.techType = SJCurveTechType_BOLL;
    }
    
    //刷新
    if (self.techType == SJCurveTechType_Volume) {
        self.techView.needDrawTechModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_Volume];
    } else if (self.techType == SJCurveTechType_KDJ) {
        self.techView.needDrawTechModels = [self.manager getKDJDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_KDJ];
    } else if (self.techType == SJCurveTechType_BOLL) {
        self.techView.needDrawTechModels = [self.manager getBOLLDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        self.techView.needDrawKlineModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_BOLL];
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    //================================================================================
    // 左右滑动逻辑说明：主k线view的宽度略大于整个k线视图的宽度，当左右滑动到主k线的边界点时，去刷新显示在主k线视图上的数据，并调整主k线视图的位置
    //================================================================================
    CGPoint scrollViewOffset = scrollView.contentOffset;
    CGFloat difValue = scrollViewOffset.x - self.previousScrollViewOffsetX;
    if (ABS(difValue) < ([MTCurveChartGlobalVariable kLineGap] + [MTCurveChartGlobalVariable kLineWidth]) || scrollViewOffset.x < 0) {
        return;
    }
    int count = ABS(difValue) / ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    if (self.previousScrollViewOffsetX > scrollViewOffset.x) {
        self.showStartIndex -= count;
    } else {
        self.showStartIndex += count;
    }
    
    // 重新获取需要显示在主k线上的数据
    if (self.showStartIndex < 0) {
        self.showStartIndex = 0;
    }
    self.mainKlineView.needDrawKlneModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
    [self.mainKlineView drawMainView];
    
    //绘制指标
    if (self.techType == SJCurveTechType_Volume) {
        self.techView.needDrawTechModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_Volume];
    } else if (self.techType == SJCurveTechType_KDJ) {
        self.techView.needDrawTechModels = [self.manager getKDJDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_KDJ];
    }else if (self.techType == SJCurveTechType_BOLL) {
        self.techView.needDrawTechModels = [self.manager getBOLLDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        self.techView.needDrawKlineModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_BOLL];
    }
    
    // 刷新主k线的位置
    CGFloat mainKlineViewPointX = self.mainKlineView.frame.origin.x + difValue;
    self.mainKlineView.frame = CGRectMake(mainKlineViewPointX, self.mainKlineView.frame.origin.y, self.mainKlineView.frame.size.width, self.mainKlineView.frame.size.height);
    self.techView.frame = CGRectMake(mainKlineViewPointX, self.techView.frame.origin.y, self.techView.frame.size.width, self.techView.frame.size.height);
    self.previousScrollViewOffsetX = scrollViewOffset.x;
}

#pragma mark - setters and getters
- (void)setManager:(MTDataManager *)manager {
    //注入数据
    _manager = manager;
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    
    //根据请求到的数据，确定scrollview的滑动区域
    CGFloat scrollViewContentWidth = ([MTCurveChartGlobalVariable kLineGap] + [MTCurveChartGlobalVariable kLineWidth]) * [self.manager getMainKLineDatas].count;
    if (scrollViewContentWidth < scrollViewWidth) {
        scrollViewContentWidth = scrollViewWidth + 1;
    }
    self.scrollView.contentSize = CGSizeMake(scrollViewContentWidth, self.scrollView.frame.size.height);
    
    //================================================================================
    //现在暂时把该方法作为k线界面的初始化入口
    //
    //================================================================================
    //初始化状态显示最新的k线数据
    CGFloat mainKlineViewWidth = self.mainKlineView.frame.size.width;
    CGFloat scrollViewFirstOffsetX = self.scrollView.contentSize.width - mainKlineViewWidth;
    self.scrollView.contentOffset = CGPointMake(scrollViewFirstOffsetX, 0);
    self.previousScrollViewOffsetX = scrollViewFirstOffsetX;
    //绘制主k线
    NSArray *mainKlineModels = [self.manager getMainKLineDatas];
    self.showStartIndex = mainKlineModels.count - self.showCount;
    self.mainKlineView.needDrawKlneModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
    [self.mainKlineView drawMainView];
    
    //绘制指标
    if (self.techType == SJCurveTechType_Volume) {
        self.techView.needDrawTechModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_Volume];
    } else if (self.techType == SJCurveTechType_KDJ) {
        self.techView.needDrawTechModels = [self.manager getKDJDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_KDJ];
    }else if (self.techType == SJCurveTechType_BOLL) {
        self.techView.needDrawTechModels = [self.manager getBOLLDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        self.techView.needDrawKlineModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.showStartIndex, self.showCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_BOLL];
    }
    
}

- (UIView *)mainKlineView {
    if (!_mainKlineView) {
        _mainKlineView = [[MTMianKLineView alloc] initWithDelegate:self];
        CGFloat mainKlineViewHeight = self.frame.size.height / 2 + 50;
        CGFloat mainKlineViewWidth = self.scrollView.frame.size.width;
        _mainKlineView.frame = CGRectMake(0, 0, mainKlineViewWidth, mainKlineViewHeight);
        
        [self.scrollView addSubview:_mainKlineView];
    }
    
    return _mainKlineView;
}

- (MTTechView *)techView {
    if (!_techView) {
        CGFloat techViewWidth = self.scrollView.frame.size.width;
        CGFloat techViewHeight = self.frame.size.height / 2 - 20 - 50;
        _techView = [[MTTechView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 + 20 + 50, techViewWidth, techViewHeight)];
        [self.scrollView addSubview:_techView];
    }
    
    return _techView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

@end
