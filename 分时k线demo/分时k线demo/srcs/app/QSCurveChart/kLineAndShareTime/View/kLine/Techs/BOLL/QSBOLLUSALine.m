//
//  QSBOLLUSALine.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBOLLUSALine.h"
#import "QSCurveChartGlobalVariable.h"
#import "QSPointPositionKLineModel.h"
#import "UIColor+CurveChart.h"

@interface QSBOLLUSALine ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation QSBOLLUSALine

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
    UIColor *lineColor = [UIColor MTCurveBlueColor];
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    //左边实线
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable kLineShadowLineWidth]);
    const CGPoint leftPoints[] = {self.positionModel.openPoint, CGPointMake(self.positionModel.openPoint.x - [QSCurveChartGlobalVariable kLineWidth] / 2, self.positionModel.openPoint.y)};
    CGContextStrokeLineSegments(context, leftPoints, 2);
    //右边实线
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable kLineShadowLineWidth]);
    const CGPoint rightPoints[] = {self.positionModel.closePoint, CGPointMake(self.positionModel.closePoint.x + [QSCurveChartGlobalVariable kLineWidth] / 2, self.positionModel.closePoint.y)};
    CGContextStrokeLineSegments(context, rightPoints, 2);
    
    //画上下影线
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable kLineShadowLineWidth]);
    const CGPoint shadowPoints[] = {self.positionModel.highPoint, self.positionModel.lowPoint};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
}

@end
