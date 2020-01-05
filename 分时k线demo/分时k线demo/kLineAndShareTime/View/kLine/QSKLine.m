//
//  QSKLine.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSKLine.h"
#import "QSPointPositionKLineModel.h"
#import "UIColor+CurveColor.h"
#import "QSCurveChartGlobalVariable.h"

@interface QSKLine ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation QSKLine

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
    //画笔的颜色
    UIColor *lineColor = self.positionModel.closePoint.y < self.positionModel.openPoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    //画中间开盘和收盘实体线
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable kLineWidth]);
    const CGPoint solidPoints[] = {self.positionModel.openPoint, self.positionModel.closePoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    //画上下影线
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable kLineShadowLineWidth]);
    const CGPoint shadowPoints[] = {self.positionModel.highPoint, self.positionModel.lowPoint};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
}

@end
