//
//  UIColor+CurveChart.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/9.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "UIColor+CurveChart.h"

@implementation UIColor (CurveChart)
#pragma mark 十六进制rgb获取颜色
+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark 涨的颜色
+(UIColor *)increaseColor {
    return [UIColor colorWithRGBHex:0xDC143C];
}

#pragma mark 跌的颜色
+(UIColor *)decreaseColor {
    return [UIColor colorWithRGBHex:0x32CD32];
}

#pragma mark 所有图表的背景颜色
+(UIColor *)backgroundColor {
    return [UIColor colorWithRGBHex:0x181c20];
}

#pragma mark 辅助背景色
+(UIColor *)assistBackgroundColor {
    return [UIColor colorWithRGBHex:0x1d2227];
}
#pragma mark 主文字颜色
+(UIColor *)mainTextColor
{
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark 辅助文字颜色
+(UIColor *)assistTextColor
{
    return [UIColor colorWithRGBHex:0x565a64];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor
{
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark ma7的颜色
+(UIColor *)ma7Color
{
    return [UIColor colorWithRGBHex:0xff783c];
}

#pragma mark ma30颜色
+(UIColor *)ma30Color
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

@end
