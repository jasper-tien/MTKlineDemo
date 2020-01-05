//
//  UIColor+CurveColor.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "UIColor+CurveColor.h"
#import "QSConstant.h"

@implementation UIColor (CurveColor)

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

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
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
    return [UIColor colorWithRGBHex:0x868a94];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor
{
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark 长按出现的方块背景颜色
+(UIColor *)longPressSelectedRectBgColor {
    return [UIColor colorWithHex:0x4682B4 alpha:0.7f];
}

#pragma mark 网格框的颜色
+ (UIColor *)gridLineColor {
    return [UIColor colorWithRGBHex:0x767a8c];
}

#pragma mark 分时线的颜色
+ (UIColor *)QSTimeLineColor {
    return [UIColor colorWithRGBHex:0x60CFFF];
}

#pragma mark 分时线下方背景色
+(UIColor *)QSTimeLineBgColor {
    return [UIColor colorWithHex:0x60CFFF alpha:0.1f];
}

#pragma mark 分时 昨收价线的颜色
+ (UIColor *)QSTimeLinePreviousClosePriceLineColor {
    return [UIColor colorWithRGBHex:0xF5FFFA];
}

#pragma mark 橙色
+(UIColor *)QSCurveOrangeColor
{
    return [UIColor colorWithRGBHex:Curve_Color_Orange];
}

#pragma mark 蓝色
+(UIColor *)QSCurveBlueColor
{
    return [UIColor colorWithRGBHex:Curve_Color_Blue];
}

#pragma mark 紫色
+(UIColor *)QSCurveVioletColor {
    return [UIColor colorWithRGBHex:Curve_Color_Violet];
}

#pragma mark 黄色
+(UIColor *)QSCurveYellowColor {
    return [UIColor colorWithRGBHex:Curve_Color_Yellow];
}

#pragma mark 绿色
+ (UIColor *)QSCurveGreenColor {
    return [UIColor colorWithRGBHex:Curve_Color_Green];
}

#pragma mark 白色
+ (UIColor *)QSCurveWhiteColor {
    return [UIColor colorWithRGBHex:Curve_Color_White];
}

@end
