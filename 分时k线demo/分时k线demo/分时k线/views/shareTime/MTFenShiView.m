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

@interface MTFenShiView ()
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
        CGPoint location = [longPress locationInView:self];
        //暂停滑动
        self.trackingCrossView.hidden = NO;
        
        //主k线或者指标view的精确位置计算
        self.trackingCrossView.crossPoint = location;
        self.trackingCrossView.showValue = 50.00;
        [self.trackingCrossView updateTrackingCrossView];
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded) {
        self.trackingCrossView.hidden = YES;
    }
}

#pragma mark -
- (MTTimeLineView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [[MTTimeLineView alloc] initWithFrame:CGRectMake(0, 0, 250, self.frame.size.height * 3 /4)];
        [self addSubview:_timeLineView];
        _timeLineView.timeLineModels = self.timeLineModels;
        [_timeLineView updateDrawModels];
    }
    
    return _timeLineView;
}

- (MTTimeLineVolumeView *)timeLineVolumeView {
    if (!_timeLineVolumeView) {
        _timeLineVolumeView = [[MTTimeLineVolumeView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 3 /4, 250, self.frame.size.height /4)];
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
