//
//  MTMALine.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/10.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTMALine.h"
#import "UIColor+CurveChart.h"
#import "SJCurveChartConstant.h"

@interface MTMALine ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation MTMALine
- (instancetype)initWithContext:(CGContextRef)context {
    if (self = [super init]) {
        self.context = context;
    }
    
    return self;
}

- (void)draw {
    if (!self.context || !self.MAPositions) {
        return;
    }
    
    UIColor *lineColor = [UIColor whiteColor];
    if (self.techType ==  SJCurveTechType_Volume || self.techType == SJCurveTechType_KLine) {
        lineColor = self.MAType == MT_MA5Type ? [UIColor MTCurveVioletColor] : (self.MAType == MT_MA10Type ? [UIColor MTCurveYellowColor] : [UIColor MTCurveBlueColor]);
    } else if (self.techType == SJCurveTechType_KDJ) {
        lineColor = self.MAType == MT_KDJ_K ? [UIColor whiteColor] : (self.MAType == MT_KDJ_D ? [UIColor MTCurveYellowColor] : [UIColor MTCurveVioletColor]);
    } else if (self.techType == SJCurveTechType_BOLL) {
        lineColor = self.MAType == MT_BOLL_UP ? [UIColor MTCurveYellowColor] : (self.MAType == MT_BOLL_MB ? [UIColor whiteColor] : [UIColor MTCurveVioletColor]);
    } else if (self.techType == SJCurveTechType_MACD) {
        lineColor = self.MAType == MT_MACD_DIF ? [UIColor whiteColor] : [UIColor MTCurveYellowColor];
    }
    
    CGContextSetStrokeColorWithColor(self.context, lineColor.CGColor);
    
    CGContextSetLineWidth(self.context, MTCurveChartMALineWidth);
    
    CGPoint firstPoint = [self.MAPositions.firstObject CGPointValue];
    NSAssert(!isnan(firstPoint.x) && !isnan(firstPoint.y), @"出现NAN值：MA画线");
    CGContextMoveToPoint(self.context, firstPoint.x, firstPoint.y);
    
    for (NSInteger idx = 1; idx < self.MAPositions.count ; idx++)
    {
        CGPoint point = [self.MAPositions[idx] CGPointValue];
        CGContextAddLineToPoint(self.context, point.x, point.y);
    }
    CGContextStrokePath(self.context);
}

@end
