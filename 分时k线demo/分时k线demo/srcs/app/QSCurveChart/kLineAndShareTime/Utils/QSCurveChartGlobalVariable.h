//
//  QSCurveChartGlobalVariable.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSCurveChartGlobalVariable : NSObject
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



#pragma mark -
//分时 成交量柱状图的宽度
+ (CGFloat)timeLineVolumeWidth;
+ (void)setTimeLineVolumeWidth:(CGFloat)volumeWidth;

//分时 成交量柱状图的间隙
+ (CGFloat)timeLineVolumeGapWidth;
+ (void)setTimeLineVolumeGapWidth:(CGFloat)volumeGapWidth;

@end

NS_ASSUME_NONNULL_END
