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

#pragma mark 曲线颜色
#define Curve_Color_None 000000000 //
#define Curve_Color_Yellow 255255000        //黄色RGB值
#define Curve_Color_White 255255255         //白色RGB值
#define Curve_Color_Blue 000000255          //蓝色RGB值
#define Curve_Color_Purple 128000128        //紫色RGB值
#define Curve_Color_Orange 255165000        //橘黄色RGB值
#define Curve_Color_Green 000128000         //绿色RGB值



