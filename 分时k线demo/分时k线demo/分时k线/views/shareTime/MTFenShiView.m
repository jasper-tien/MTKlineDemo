//
//  MTFenShiView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTFenShiView.h"
#import "UIColor+CurveChart.h"
#import "MTTimeLineView.h"
#import "MTTimeLineVolumeView.h"
#import "MTTimeLineTrackingCrossView.h"
#import "MTTimeLineTableView.h"
#import "MTCurveChartGlobalVariable.h"

#import "MTTimeLineModel.h"

@interface MTFenShiView () <MTTimeLineViewDelegate, MTTimeLineVolumeViewDelegate>
@property (nonatomic, strong) NSMutableArray<MTTimeLineModel *> *sourceTimeLineModels;
@property (nonatomic, strong) MTTimeLineView *timeLineView;
@property (nonatomic, strong) MTTimeLineVolumeView *timeLineVolumeView;
@property (nonatomic, strong) MTTimeLineTrackingCrossView *trackingCrossView;
@property (nonatomic, strong) MTTimeLineTableView *timeLineTableView;
@end

@implementation MTFenShiView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor assistBackgroundColor];
        
        self.sourceTimeLineModels = @[].mutableCopy;
        //添加子控件
        [self addSubview:self.timeLineView];
        [self addSubview:self.timeLineVolumeView];
        [self addSubview:self.timeLineTableView];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMethod:)];
        [self addGestureRecognizer:longPressGesture];
    }
    
    return self;
}

#pragma mark -
- (void)updateDrawTimeLine {
    _timeLineView.timeLineModels = self.sourceTimeLineModels;
    [_timeLineView updateDrawModels];
    
    _timeLineVolumeView.needDrawVolumeModels = self.sourceTimeLineModels;
    [_timeLineVolumeView updateDrawModels];
}

- (void)updateDrawTimeLineWithNewTimeLineModel:(MTTimeLineModel *)newTimeLineModel isSameTime:(BOOL)isSameTime{
    if (isSameTime) {
        [self.sourceTimeLineModels removeLastObject];
    }
    [self.sourceTimeLineModels addObject:newTimeLineModel];
    
    [self updateDrawTimeLine];
}

#pragma mark 长按手势执行方法
- (void)longPressMethod:(UILongPressGestureRecognizer *)longPress {
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self.timeLineView];
        //暂停滑动
        self.trackingCrossView.hidden = NO;
        //主k线或者指标view的精确位置计算
        self.trackingCrossView.maxPointX = self.timeLineModels.count * ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
        if (location.y > self.timeLineVolumeView.frame.origin.y) {
            location = [longPress locationInView:self.timeLineVolumeView];
            [self.timeLineVolumeView longPressOrMovingAtPoint:location];
        } else {
            [self.timeLineView longPressOrMovingAtPoint:location];
        }
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded) {
        self.trackingCrossView.hidden = YES;
    }
}

#pragma mark - timeLineView delegate
- (void)timeLineViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressPrice:(CGFloat)price {
    self.trackingCrossView.showValue = price;
    CGFloat trackingCrossViewPointX = longPressPosition.x;
    if (trackingCrossViewPointX < 0) {
        trackingCrossViewPointX = 0;
    }
    if (trackingCrossViewPointX > self.timeLineView.frame.size.width) {
        trackingCrossViewPointX = self.timeLineView.frame.size.width;
    }
    CGFloat trackingCrossViewPointY = longPressPosition.y;
    if (trackingCrossViewPointY < 0) {
        trackingCrossViewPointY = 0;
    }
    self.trackingCrossView.crossPoint = CGPointMake(trackingCrossViewPointX, trackingCrossViewPointY);
    [self.trackingCrossView updateTrackingCrossView];
}

#pragma mark - timeLineVolumeView delegate
- (void)timeLineVolumeViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressVolume:(CGFloat)volume {
    CGFloat trackingCrossViewPointX = longPressPosition.x;
    if (trackingCrossViewPointX < 0) {
        trackingCrossViewPointX = 0;
    }
    if (trackingCrossViewPointX > self.timeLineVolumeView.frame.size.width) {
        trackingCrossViewPointX = self.timeLineVolumeView.frame.size.width;
    }
    CGFloat trackingCrossViewPointY = longPressPosition.y+ self.timeLineVolumeView.frame.origin.y;
    if (trackingCrossViewPointY > (self.timeLineVolumeView.frame.size.height + self.timeLineVolumeView.frame.origin.y) ) {
        trackingCrossViewPointY = self.timeLineVolumeView.frame.size.height + self.timeLineVolumeView.frame.origin.y;
    } 
    self.trackingCrossView.showValue = volume;
    self.trackingCrossView.crossPoint = CGPointMake(trackingCrossViewPointX, trackingCrossViewPointY);
    [self.trackingCrossView updateTrackingCrossView];
}

#pragma mark -
- (MTTimeLineView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [[MTTimeLineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 110, self.frame.size.height * 3 /4)];
        _timeLineView.delegate = self;
        _timeLineView.timeLineModels = self.timeLineModels;
        [_timeLineView updateDrawModels];
    }
    
    return _timeLineView;
}

- (MTTimeLineVolumeView *)timeLineVolumeView {
    if (!_timeLineVolumeView) {
        _timeLineVolumeView = [[MTTimeLineVolumeView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 3 /4, self.frame.size.width - 110, self.frame.size.height /4)];
        _timeLineVolumeView.delegate = self;
    }
    
    return _timeLineVolumeView;
}

- (MTTimeLineTrackingCrossView *)trackingCrossView {
    if (!_trackingCrossView) {
        _trackingCrossView = [[MTTimeLineTrackingCrossView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 110, self.frame.size.height) crossPoint:CGPointZero];
        [self addSubview:_trackingCrossView];
    }
    
    return _trackingCrossView;
}

- (MTTimeLineTableView *)timeLineTableView {
    if (!_timeLineTableView) {
        _timeLineTableView = [[MTTimeLineTableView alloc] initWithFrame:CGRectMake(self.frame.size.width - 110, 0, 110, self.frame.size.height)];
    }
    
    return _timeLineTableView;
}

- (void)setTimeLineModels:(NSArray<MTTimeLineModel *> *)timeLineModels {
    if (self.sourceTimeLineModels.count > 0) {
        [self.sourceTimeLineModels removeAllObjects];
    }
    
    [self.sourceTimeLineModels addObjectsFromArray:timeLineModels];
}

@end
