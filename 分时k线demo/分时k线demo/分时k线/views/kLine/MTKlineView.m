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
//
@property (nonatomic, strong) MTTechView *techView;
//
@property (nonatomic, assign) SJCurveTechType techType;
//记录ScrollView上一次次滑动的偏移量
@property (nonatomic, assign) CGFloat previousScrollViewOffsetX;
//开始显示数据的index
@property (nonatomic, assign) NSInteger startIndex;
@end

@implementation MTKlineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor assistBackgroundColor];
        self.previousScrollViewOffsetX = 0;
        self.techType = SJCurveTechType_KDJ;
    }
    
    return self;
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
        self.startIndex -= count;
    } else {
        self.startIndex += count;
    }
    
    // 重新获取需要显示在主k线上的数据
    NSInteger mainKlineViewShowCount = self.mainKlineView.frame.size.width / ([MTCurveChartGlobalVariable kLineGap] + [MTCurveChartGlobalVariable kLineWidth]);
    NSInteger length = mainKlineViewShowCount;
    if (self.startIndex < 0) {
        self.startIndex = 0;
        length += self.startIndex;
    }
    self.mainKlineView.needDrawKlneModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.startIndex, length)];
    [self.mainKlineView drawMainView];
    
    //绘制指标
    if (self.techType == SJCurveTechType_Volume) {
        self.techView.needDrawTechModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.startIndex, mainKlineViewShowCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_Volume];
    } else if (self.techType == SJCurveTechType_KDJ) {
        self.techView.needDrawTechModels = [self.manager getKDJDatasWithRange:NSMakeRange(self.startIndex, mainKlineViewShowCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_KDJ];
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
    NSInteger mainKlineViewShowCount = self.mainKlineView.frame.size.width / ([MTCurveChartGlobalVariable kLineGap] + [MTCurveChartGlobalVariable kLineWidth]);
    NSArray *mainKlineModels = [self.manager getMainKLineDatas];
    self.startIndex = mainKlineModels.count - mainKlineViewShowCount;
    self.mainKlineView.needDrawKlneModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.startIndex, mainKlineViewShowCount)];
    [self.mainKlineView drawMainView];
    
    //绘制指标
    if (self.techType == SJCurveTechType_Volume) {
        self.techView.needDrawTechModels = [self.manager getMainKLineDatasWithRange:NSMakeRange(self.startIndex, mainKlineViewShowCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_Volume];
    } else if (self.techType == SJCurveTechType_KDJ) {
        self.techView.needDrawTechModels = [self.manager getKDJDatasWithRange:NSMakeRange(self.startIndex, mainKlineViewShowCount)];
        [self.techView drawTechViewWithType:SJCurveTechType_KDJ];
    }
    
}

- (UIView *)mainKlineView {
    if (!_mainKlineView) {
        _mainKlineView = [[MTMianKLineView alloc] initWithDelegate:self];
        CGFloat mainKlineViewHeight = self.frame.size.height / 2;
        CGFloat mainKlineViewWidth = self.scrollView.frame.size.width;
        _mainKlineView.frame = CGRectMake(0, 0, mainKlineViewWidth, mainKlineViewHeight);
        
        [self.scrollView addSubview:_mainKlineView];
    }
    
    return _mainKlineView;
}

- (MTTechView *)techView {
    if (!_techView) {
        CGFloat techViewWidth = self.scrollView.frame.size.width;
        CGFloat techViewHeight = self.frame.size.height / 2 - 20;
        _techView = [[MTTechView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 + 20, techViewWidth, techViewHeight)];
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
