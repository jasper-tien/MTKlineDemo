//
//  MTTrackingCrossView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/17.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTrackingCrossView.h"
#import "UIColor+CurveChart.h"
#import "SJCurveChartConstant.h"

@interface MTTrackingCrossView ()

@end

@implementation MTTrackingCrossView

- (instancetype)initWithFrame:(CGRect)frame crossPoint:(CGPoint)crossPoint dateRect:(CGRect)dateRect {
    if (self = [super initWithFrame:frame]) {
        self.crossPoint = crossPoint;
        self.dateRect = dateRect;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.crossPoint.x > self.frame.size.width || self.crossPoint.x  < 0 || self.crossPoint.y > self.frame.size.height || self.crossPoint.y < 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawVerticalLine:context];
    
    [self drawHorizontalLine:context];
}

//竖线
- (void)drawVerticalLine:(CGContextRef)context {
    
    CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
    CGContextSetLineWidth(context, MTCurveChartTrackingCrossLineWidth);
    
    const CGPoint verticalLinePoint1s[] = {CGPointMake(self.crossPoint.x, 0), CGPointMake(self.crossPoint.x, self.dateRect.origin.y)};
    CGContextStrokeLineSegments(context, verticalLinePoint1s, 2);
    
    const CGPoint verticalLinePoint2s[] = {CGPointMake(self.crossPoint.x, self.dateRect.origin.y + self.dateRect.size.height), CGPointMake(self.crossPoint.x, self.frame.size.height)};
    CGContextStrokeLineSegments(context, verticalLinePoint2s, 2);
    
}

//横线
- (void)drawHorizontalLine:(CGContextRef)context {
    if (self.crossPoint.y < self.dateRect.origin.y || self.crossPoint.y > (self.dateRect.origin.y + self.dateRect.size.height)) {
        CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
        CGContextSetLineWidth(context, MTCurveChartTrackingCrossLineWidth);
        const CGPoint horizontalLinePoints[] = {CGPointMake(0, self.crossPoint.y), CGPointMake(self.frame.size.width, self.crossPoint.y)};
        CGContextStrokeLineSegments(context, horizontalLinePoints, 2);
    }
}

- (void)updateTrackingCrossView {
    [self setNeedsDisplay];
}

@end
