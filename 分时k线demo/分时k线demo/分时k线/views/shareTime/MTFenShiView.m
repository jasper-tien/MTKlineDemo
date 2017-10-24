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

@interface MTFenShiView () <MTTimeLineViewDelegate, MTTimeLineVolumeViewDelegate>
@property (nonatomic, strong) MTTimeLineView *timeLineView;
@property (nonatomic, strong) MTTimeLineVolumeView *timeLineVolumeView;
@property (nonatomic, strong) MTTimeLineTrackingCrossView *trackingCrossView;
@property (nonatomic, strong) MTTimeLineTableView *timeLineTableView;
@end

@implementation MTFenShiView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor assistBackgroundColor];
        NSLog(@"%@ %@ %@", self.timeLineView, self.timeLineVolumeView, self.timeLineTableView);
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMethod:)];
        [self addGestureRecognizer:longPressGesture];
    }
    
    return self;
}

- (void)updateDrawTimeLine {
    _timeLineView.timeLineModels = self.timeLineModels;
    [_timeLineView updateDrawModels];
    
    _timeLineVolumeView.needDrawVolumeModels = self.timeLineModels;
    [_timeLineVolumeView updateDrawModels];
}

#pragma mark 长按手势执行方法
- (void)longPressMethod:(UILongPressGestureRecognizer *)longPress {
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self.timeLineView];
        //暂停滑动
        self.trackingCrossView.hidden = NO;
        //主k线或者指标view的精确位置计算
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
        _timeLineView = [[MTTimeLineView alloc] initWithFrame:CGRectMake(0, 0, 250, self.frame.size.height * 3 /4)];
        _timeLineView.delegate = self;
        [self addSubview:_timeLineView];
        _timeLineView.timeLineModels = self.timeLineModels;
        [_timeLineView updateDrawModels];
    }
    
    return _timeLineView;
}

- (MTTimeLineVolumeView *)timeLineVolumeView {
    if (!_timeLineVolumeView) {
        _timeLineVolumeView = [[MTTimeLineVolumeView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 3 /4, 250, self.frame.size.height /4)];
        _timeLineVolumeView.delegate = self;
        [self addSubview:_timeLineVolumeView];
    }
    
    return _timeLineVolumeView;
}

- (MTTimeLineTrackingCrossView *)trackingCrossView {
    if (!_trackingCrossView) {
        _trackingCrossView = [[MTTimeLineTrackingCrossView alloc] initWithFrame:CGRectMake(0, 0, 250, self.frame.size.height) crossPoint:CGPointZero];
        [self addSubview:_trackingCrossView];
    }
    
    return _trackingCrossView;
}

- (MTTimeLineTableView *)timeLineTableView {
    if (!_timeLineTableView) {
        _timeLineTableView = [[MTTimeLineTableView alloc] initWithFrame:CGRectMake(250, 0, self.frame.size.width - 250, self.frame.size.height)];
        [self addSubview:_timeLineTableView];
    }
    
    return _timeLineTableView;
}

@end
