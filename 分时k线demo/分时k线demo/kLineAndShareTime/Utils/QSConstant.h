//
//  QSConstant.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#ifndef QSConstant_h
#define QSConstant_h

//曲线类型
typedef NS_ENUM(NSInteger, QSCurveTechType) {
    QSCurveTechType_KLine = 0,      //K线
    QSCurveTechType_Volume,         //成交量
    QSCurveTechType_Jine,           //成交额
    QSCurveTechType_MACD,           //MACD线
    QSCurveTechType_KDJ,            //KDJ线
    QSCurveTechType_BOLL,           //BOLL线（布林线）
};

/**
 *  K线最大的宽度
 */
#define QSCurveChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define QSCurveChartKLineMinWidth 2
/**
 *  K线图上可画区域最小的Y
 */
#define QSCurveChartKLineMainViewMinY 20
/**
 *  均线宽度
 */
#define QSCurveChartMALineWidth 1

/**
 *  K线图的成交量上最小的Y
 */
#define  QSCurveChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define  QSCurveChartKLineVolumeViewMaxY (self.frame.size.height)
/**
 *  K线图的副图上最小的Y
 */
#define QSCurveChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define QSCurveChartKLineAccessoryViewMaxY (self.frame.size.height)
/**
 *  K线图缩放界限
 */
#define QSCurveChartKLineScaleBound 0.05
/**
 *  K线的缩放因子
 */
#define QSCurveChartKLineScaleFactor 0.08
/**
 *  十字光标线的宽度
 */
#define QSCurveChartTrackingCrossLineWidth 1

//float最大值
#define QSCurveChartFloatMax CGFLOAT_MAX
//float最小值
#define QSCurveChartFloatMin CGFLOAT_MIN

#pragma mark -
//分时线的宽度
#define QSCurveChartTimeLineWidth 1

#pragma mark 曲线颜色
#define Curve_Color_Yellow 0xffff00        //黄色RGB值
#define Curve_Color_White 0xffffff         //白色RGB值
#define Curve_Color_Blue 0x49a5ff          //蓝色RGB值
#define Curve_Color_Violet 0x8b008b        //紫色RGB值
#define Curve_Color_Orange 0xff783c        //橘色RGB值
#define Curve_Color_Green 0x32cd32         //绿色RGB值

#endif /* QSConstant_h */
