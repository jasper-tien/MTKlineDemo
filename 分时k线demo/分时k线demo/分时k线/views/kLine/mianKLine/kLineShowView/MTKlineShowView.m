//
//  MTKlineShowView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/17.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTKlineShowView.h"
#import "UIColor+CurveChart.h"

@implementation MTKlineShowView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleStr = @"";
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGPoint drawTitlePoint = CGPointMake(40, 0);
    [self.titleStr drawAtPoint:drawTitlePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
}

- (void)redrawWithString:(NSString *)string {
    self.titleStr = string;
    [self setNeedsDisplay];
}

@end
