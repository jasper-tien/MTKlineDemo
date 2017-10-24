//
//  MTTimeLineTrackingCrossView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTimeLineTrackingCrossView.h"
#import "UIColor+CurveChart.h"
#import "SJCurveChartConstant.h"

@implementation MTTimeLineTrackingCrossView

- (instancetype)initWithFrame:(CGRect)frame crossPoint:(CGPoint)crossPoint {
    if (self = [super initWithFrame:frame]) {
        self.crossPoint = crossPoint;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.showValue = 0.0;
        self.crossPoint = CGPointZero;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawVerticalLine:context];
    
    [self drawHorizontalLine:context];
    
    [self drawSelectedPart:context];
}

//竖线
- (void)drawVerticalLine:(CGContextRef)context {
    
    CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
    CGContextSetLineWidth(context, MTCurveChartTrackingCrossLineWidth);
    
    const CGPoint verticalLinePoints[] = {CGPointMake(self.crossPoint.x, 0), CGPointMake(self.crossPoint.x, self.frame.size.height)};
    CGContextStrokeLineSegments(context, verticalLinePoints, 2);
}

//横线
- (void)drawHorizontalLine:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
    CGContextSetLineWidth(context, MTCurveChartTrackingCrossLineWidth);
    const CGPoint horizontalLinePoints[] = {CGPointMake(0, self.crossPoint.y), CGPointMake(self.frame.size.width, self.crossPoint.y)};
    CGContextStrokeLineSegments(context, horizontalLinePoints, 2);
}

- (void)drawSelectedPart:(CGContextRef)context {
    //绘制选中价格
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor mainTextColor]};
    NSString *priceText = [NSString stringWithFormat:@"%.2f",self.showValue];
    CGRect priceRect = [self rectOfNSString:priceText attribute:attribute];
    CGFloat pricePointY = self.crossPoint.y - priceRect.size.height / 2;
    CGFloat pricePointX = 0;
    //y轴临界值判断
    if (pricePointY < priceRect.size.height / 2) {
        pricePointY = priceRect.size.height / 2;
    }
    if (pricePointY > (self.bounds.size.height - priceRect.size.height)) {
        pricePointY = self.bounds.size.height - priceRect.size.height;
    }
    //x轴临界值判断
    if (self.crossPoint.x < priceRect.size.width + 10) {
        pricePointX = self.bounds.size.width - priceRect.size.width;
    }
    if (self.crossPoint.x > (self.bounds.size.width - priceRect.size.width - 10)) {
        pricePointX = 0;
    }
    
    CGRect priceDrawRect= CGRectMake(pricePointX, pricePointY, priceRect.size.width, priceRect.size.height);
    CGContextSetFillColorWithColor(context, [UIColor longPressSelectedRectBgColor].CGColor);
    CGContextFillRect(context, priceDrawRect);
    [priceText drawInRect:priceDrawRect withAttributes:attribute];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

- (void)updateTrackingCrossView {
    [self setNeedsDisplay];
}

@end
