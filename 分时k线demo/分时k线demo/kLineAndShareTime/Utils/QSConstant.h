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

#endif /* QSConstant_h */
