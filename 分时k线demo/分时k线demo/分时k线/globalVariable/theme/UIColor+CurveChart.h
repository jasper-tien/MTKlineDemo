//
//  UIColor+CurveChart.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/9.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CurveChart)
/**
 *  根据十六进制转换成UIColor
 *
 *  @param hex UIColor的十六进制
 *
 *  @return 转换后的结果
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
/**
 *  涨的颜色
 */
+ (UIColor *)increaseColor;


/**
 *  跌的颜色
 */
+ (UIColor *)decreaseColor;
/**
 *  所有图表的背景颜色
 */
+ (UIColor *)backgroundColor;

/**
 *  辅助背景色
 */
+ (UIColor *)assistBackgroundColor;
/**
 *  主文字颜色
 */
+ (UIColor *)mainTextColor;

/**
 *  辅助文字颜色
 */
+ (UIColor *)assistTextColor;
/**
 *  长按时线的颜色
 */
+ (UIColor *)longPressLineColor;
/**
 *  橙色
 */
+ (UIColor *)MTCurveOrangeColor;
/**
 *  蓝色
 */
+ (UIColor *)MTCurveBlueColor;
/**
 *  紫色
 */
+ (UIColor *)MTCurveVioletColor;
/**
 *  黄色
 */
+ (UIColor *)MTCurveYellowColor;
/**
 *  绿色
 */
+ (UIColor *)MTCurveGreenColor;
/**
 *  白色
 */
+ (UIColor *)MTCurveWhiteColor;

@end
