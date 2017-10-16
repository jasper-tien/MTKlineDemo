//
//  MTCurveChartGlobalVariable.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/9.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MTCurveChartGlobalVariable : NSObject
/**
 *  K线图的宽度，默认5
 */
+(CGFloat)kLineWidth;
+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;
+(void)setkLineGap:(CGFloat)kLineGap;

/**
 *  K线图上下影线的宽度
 */
+ (CGFloat)kLineShadowLineWidth;
+ (void)setKlineShadowLineWidth:(CGFloat)shadowLineWidth;
/**
 *  网格格线的宽度
 */
+ (CGFloat)CurveChactGridLineWidth;
+ (void)setCurveChartGridLineWidth:(CGFloat)gridLineWith;

@end
