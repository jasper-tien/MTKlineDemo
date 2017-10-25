//
//  MTShowDetailsView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/25.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTShowDetailsView.h"
#import "UIColor+CurveChart.h"

@implementation MTShowDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.startPointX = 0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat pointX= self.startPointX;
    CGFloat pointY = 0;
    CGFloat gap = 8;
    for (int i = 0; i < self.contentArray.count; i++) {
        NSDictionary *dic = self.contentArray[i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            break;
        }
        NSString *contentStr = dic[@"content"];
        if (contentStr && ![contentStr isEqualToString:@""]) {
            NSString *typeStr =dic[@"type"];
            UIColor *contentColor = dic[@"color"];
            if (!contentColor || ![contentColor isKindOfClass:[UIColor class]]) {
                contentColor = [UIColor mainTextColor];
            }
            
            if ([@"1" isEqualToString:typeStr]) {
                //绘制交叉圆点
                CGContextSetStrokeColorWithColor(context, contentColor.CGColor);
                CGContextSetFillColorWithColor(context, contentColor.CGColor);
                CGContextSetLineWidth(context, 1.5);
                CGContextSetLineDash(context, 0, NULL, 0);
                CGContextAddArc(context, pointX, 8, 1.5, 0, 2 * M_PI, 0);
                CGContextDrawPath(context, kCGPathFillStroke);
                pointX = pointX + 5;
                
                contentColor = [UIColor assistTextColor];
            }
            
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:contentColor};
            CGRect contentRect = [self rectOfNSString:contentStr attribute:attribute];
            CGRect contentDrawRect= CGRectMake(pointX, pointY, contentRect.size.width, contentRect.size.height);
            [contentStr drawInRect:contentDrawRect withAttributes:attribute];
            pointX = gap + contentDrawRect.origin.x + contentDrawRect.size.width;
        }
    }
}

- (void)redrawWithArray:(NSArray *)array {
    if (array.count <= 0) {
        return;
    }
    self.contentArray = array;
    [self setNeedsDisplay];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
