//
//  MTVolume.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTVolume.h"
#import "MTCurveChartGlobalVariable.h"
@interface MTVolume ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation MTVolume
- (instancetype)initWithContext:(CGContextRef)context {
    if (self = [super init]) {
        self.context = context;
    }
    
    return self;
}

- (void)draw {
    if (!self.context || !self.positionModel) {
        return;
    }
    
    CGContextRef context = self.context;
    CGContextSetStrokeColorWithColor(context, self.positionModel.color.CGColor);
    //画中间开盘和收盘实体线
    CGContextSetLineWidth(context, [MTCurveChartGlobalVariable kLineWidth]);
    const CGPoint solidPoints[] = {self.positionModel.volumePoint, self.positionModel.startPoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
}
@end

