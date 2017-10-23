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

@interface MTFenShiView ()
@property (nonatomic, strong) MTTimeLineView *timeLineView;
@property (nonatomic, strong) MTTimeLineVolumeView *timeLineVolumeView;
@end

@implementation MTFenShiView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor assistBackgroundColor];
        NSLog(@"%@ %@", self.timeLineView, self.timeLineVolumeView);
    }
    
    return self;
}

- (void)updateDrawTimeLine {
    _timeLineView.timeLineModels = self.timeLineModels;
    [_timeLineView updateDrawModels];
    
    _timeLineVolumeView.needDrawVolumeModels = self.timeLineModels;
    [_timeLineVolumeView updateDrawModels];
}

#pragma mark -
- (MTTimeLineView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [[MTTimeLineView alloc] initWithFrame:CGRectMake(0, 0, 300, self.frame.size.height * 3 /4)];
        [self addSubview:_timeLineView];
        _timeLineView.timeLineModels = self.timeLineModels;
        [_timeLineView updateDrawModels];
    }
    
    return _timeLineView;
}

- (MTTimeLineVolumeView *)timeLineVolumeView {
    if (!_timeLineVolumeView) {
        _timeLineVolumeView = [[MTTimeLineVolumeView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 3 /4, 300, self.frame.size.height /4)];
        [self addSubview:_timeLineVolumeView];
    }
    
    return _timeLineVolumeView;
}

@end
