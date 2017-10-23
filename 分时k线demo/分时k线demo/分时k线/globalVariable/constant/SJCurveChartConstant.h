//
//  SJCurveChartConstant.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/19.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#ifndef SJCurveChartConstant_h
#define SJCurveChartConstant_h


#endif /* SJCurveChartConstant_h */
//曲线类型
typedef NS_ENUM(NSInteger, SJCurveTechType) {
    SJCurveTechType_KLine = 0,      //K线
    SJCurveTechType_Volume,         //成交量
    SJCurveTechType_Jine,           //成交额
    SJCurveTechType_MACD,           //MACD线
    SJCurveTechType_KDJ,            //KDJ线
    SJCurveTechType_BOLL,           //BOLL线（布林线）
};

//k线类型
typedef NS_ENUM(NSInteger, SJKlineType) {
    SJKlineType_1min = 0,       //一分钟
    SJKlineType_5min,           //5分钟
    SJKlineType_15min,          //15分钟
    SJKlineType_30min,          //30分钟
    SJKlineType_60min,          //60分钟
    SJKlineType_Day,            //日线
    SJKlineType_Week,           //周线
    SJKlineType_Month,          //月线
    SJKlineType_Year            //年线
};

//曲线绘制的种类
typedef NS_ENUM(NSInteger, SJCurveShowType) {
    SJCurveShowType_None = 0,
    SJCurveShowType_KLine,          //k线
    SJCurveShowType_Volume,         //成交量
    SJCurveShowType_Jine,           //成交额
    SJCurveShowType_PointLine,      //点连线，如：均线
    SJCurveShowType_BOLL,           //布林线
    SJCurveShowType_RedGreenUpOrDown//有基准线的，如：MACD
};

/**
 *  K线最大的宽度
 */
#define MTCurveChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define MTCurveChartKLineMinWidth 2
/**
 *  K线图上可画区域最小的Y
 */
#define MTCurveChartKLineMainViewMinY 20
/**
 *  均线宽度
 */
#define MTCurveChartMALineWidth 1

/**
 *  K线图的成交量上最小的Y
 */
#define  MTCurveChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define  MTCurveChartKLineVolumeViewMaxY (self.frame.size.height)
/**
 *  K线图的副图上最小的Y
 */
#define MTCurveChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define MTCurveChartKLineAccessoryViewMaxY (self.frame.size.height)
/**
 *  K线图缩放界限
 */
#define MTCurveChartKLineScaleBound 0.05
/**
 *  K线的缩放因子
 */
#define MTCurveChartKLineScaleFactor 0.08
/**
 *  十字光标线的宽度
 */
#define MTCurveChartTrackingCrossLineWidth 1

//float最大值
#define MTCurveChartFloatMax CGFLOAT_MAX
//float最小值
#define MTCurveChartFloatMin CGFLOAT_MIN

#pragma mark 曲线颜色
#define Curve_Color_Yellow 0xffff00        //黄色RGB值
#define Curve_Color_White 0xffffff         //白色RGB值
#define Curve_Color_Blue 0x49a5ff          //蓝色RGB值
#define Curve_Color_Violet 0x8b008b        //紫色RGB值
#define Curve_Color_Orange 0xff783c        //橘色RGB值
#define Curve_Color_Green 0x32cd32         //绿色RGB值



