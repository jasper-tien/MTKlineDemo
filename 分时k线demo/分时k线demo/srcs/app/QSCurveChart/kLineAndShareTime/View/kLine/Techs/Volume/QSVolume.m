//
//  QSVolume.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSVolume.h"
#import "QSCurveChartGlobalVariable.h"

@interface QSVolume ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation QSVolume
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
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable kLineWidth]);
    const CGPoint solidPoints[] = {self.positionModel.volumePoint, self.positionModel.startPoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
}

@end
