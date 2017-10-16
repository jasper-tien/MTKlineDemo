//
//  MTCurveChartGlobalVariable.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/9.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTCurveChartGlobalVariable.h"
#import "SJCurveChartConstant.h"

@implementation MTCurveChartGlobalVariable
/**
 *  K线图的宽度，默认5
 */
static CGFloat mtCurveChartKlineWith = 5;
/**
 *  K线图的间隔，默认1
 */
static CGFloat mtCurveChartKlineGap = 1;
/**
 *  K线图的间隔，默认1
 */
static CGFloat mtCurveChartKlineShadowLineWith = 1;
/**
 *  网格格线的宽度,默认0.5
 */
static CGFloat mtCurveChartGridLineWidth = 0.3;

#pragma mark K线图的宽度
+(CGFloat)kLineWidth {
    return mtCurveChartKlineWith;
}

+ (void)setkLineWith:(CGFloat)kLineWidth {
    if (kLineWidth > MTCurveChartKLineMaxWidth) {
        kLineWidth = MTCurveChartKLineMaxWidth;
    } else if (kLineWidth < MTCurveChartKLineMinWidth) {
        kLineWidth = MTCurveChartKLineMinWidth;
    }
    mtCurveChartKlineWith = kLineWidth;
}

#pragma mark K线图的间隔
+(CGFloat)kLineGap {
    return mtCurveChartKlineGap;
}

+ (void)setkLineGap:(CGFloat)kLineGap {
    mtCurveChartKlineGap = kLineGap;
}

#pragma mark K线图上下影线的宽度
+ (CGFloat)kLineShadowLineWidth {
    return mtCurveChartKlineShadowLineWith;
}

+ (void)setKlineShadowLineWidth:(CGFloat)shadowLineWidth {
    mtCurveChartKlineShadowLineWith = shadowLineWidth;
}

#pragma mark 网格格线的宽度
+ (CGFloat)CurveChactGridLineWidth {
    return mtCurveChartGridLineWidth;
}
+ (void)setCurveChartGridLineWidth:(CGFloat)gridLineWith {
    mtCurveChartGridLineWidth = gridLineWith;
}

@end
