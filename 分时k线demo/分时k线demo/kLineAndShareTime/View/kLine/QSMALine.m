//
//  QSMALine.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSMALine.h"
#import "UIColor+CurveColor.h"

@interface QSMALine ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation QSMALine

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
    if (self.techType ==  QSCurveTechType_Volume || self.techType == QSCurveTechType_KLine) {
        lineColor = self.MAType == MT_MA5Type ? [UIColor QSCurveVioletColor] : (self.MAType == MT_MA10Type ? [UIColor QSCurveYellowColor] : [UIColor QSCurveBlueColor]);
    } else if (self.techType == QSCurveTechType_KDJ) {
        lineColor = self.MAType == MT_KDJ_K ? [UIColor whiteColor] : (self.MAType == MT_KDJ_D ? [UIColor QSCurveYellowColor] : [UIColor QSCurveVioletColor]);
    } else if (self.techType == QSCurveTechType_BOLL) {
        lineColor = self.MAType == MT_BOLL_UP ? [UIColor QSCurveYellowColor] : (self.MAType == MT_BOLL_MB ? [UIColor whiteColor] : [UIColor QSCurveVioletColor]);
    } else if (self.techType == QSCurveTechType_MACD) {
        lineColor = self.MAType == MT_MACD_DIF ? [UIColor whiteColor] : [UIColor QSCurveYellowColor];
    }
    
    CGContextSetStrokeColorWithColor(self.context, lineColor.CGColor);
    
    CGContextSetLineWidth(self.context, QSCurveChartMALineWidth);
    
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
