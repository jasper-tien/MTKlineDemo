//
//  MTMACDLine.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/13.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTMACDLine.h"
#import "UIColor+CurveChart.h"
#import "MTCurveChartGlobalVariable.h"

@interface MTMACDLine ()
@property (nonatomic, assign) CGContextRef context;
@end

@implementation MTMACDLine
- (instancetype)initWithContext:(CGContextRef)context {
    if (self = [super init]) {
        self.context = context;
        self.zeroPointY = 0;
    }
    
    return self;
}

- (void)draw {
    if (!self.context || self.MACDPositions.count <= 0) {
        return;
    }
    
    CGContextRef context = self.context;
    [self.MACDPositions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *positionValue = obj;
        CGPoint positionPoint = positionValue.CGPointValue;
        //画笔的颜色
        UIColor *lineColor = [UIColor whiteColor];
        if (positionPoint.y > self.zeroPointY) {
            lineColor = [UIColor greenColor];
        } else {
            lineColor = [UIColor redColor];
        }
        
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        CGContextSetLineWidth(context, [MTCurveChartGlobalVariable kLineWidth]);
        const CGPoint solidPoints[] = {CGPointMake(positionPoint.x, self.zeroPointY), positionPoint};
        CGContextStrokeLineSegments(context, solidPoints, 2);
    }];
    
}
@end
