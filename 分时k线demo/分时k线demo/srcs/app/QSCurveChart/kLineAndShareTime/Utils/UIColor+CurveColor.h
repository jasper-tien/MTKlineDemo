//
//  UIColor+CurveColor.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CurveColor)
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
 *  长按出现的方块背景颜色
 */
+(UIColor *)longPressSelectedRectBgColor;
/**
 *  网格框的颜色
 */
+ (UIColor *)gridLineColor;
/**
 *  分时线的颜色
 */
+ (UIColor *)QSTimeLineColor;
/**
 *  分时线下方背景色
 */
+(UIColor *)QSTimeLineBgColor;
/**
 *  分时 昨收价线的颜色
 */
+ (UIColor *)QSTimeLinePreviousClosePriceLineColor;
/**
 *  橙色
 */
+ (UIColor *)QSCurveOrangeColor;
/**
 *  蓝色
 */
+ (UIColor *)QSCurveBlueColor;
/**
 *  紫色
 */
+ (UIColor *)QSCurveVioletColor;
/**
 *  黄色
 */
+ (UIColor *)QSCurveYellowColor;
/**
 *  绿色
 */
+ (UIColor *)QSCurveGreenColor;
/**
 *  白色
 */
+ (UIColor *)QSCurveWhiteColor;

@end

NS_ASSUME_NONNULL_END
