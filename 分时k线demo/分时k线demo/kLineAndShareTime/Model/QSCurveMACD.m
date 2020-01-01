//
//  QSCurveMACD.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSCurveMACD.h"

@implementation QSCurveMACD

- (instancetype)init {
    if (self = [super init]) {
        self.curveTechType = QSCurveTechType_MACD;
    }
    
    return self;
}

-(void)reckonTechWithArray:(NSArray<QSKlineModel *> *)baseDatas container:(NSArray<QSCurveModel *> *)supArray index:(NSInteger)index {
    [super reckonTechWithArray:baseDatas container:supArray index:index];
    //在此方法中计算指标
    QSKlineModel *model = baseDatas[index];
    if (index > 0) {
        QSCurveMACD *previousCurveMACD = (QSCurveMACD *)supArray[index - 1];
        self.EMA12 = previousCurveMACD.EMA12 * 11 / 13 + model.close * 2 / 13;
        self.EMA26 = previousCurveMACD.EMA26 * 25 / 27 + model.close * 2 / 27;
        self.DIF = self.EMA12 - self.EMA26;
        self.DEA = previousCurveMACD.DEA * 8 / 10 + self.DIF * 2 / 10;
        self.MACD = 2 * (self.DIF - self.DEA);
    } else {
        self.EMA12 = model.close;
        self.EMA26 = model.close;
        self.DIF = 0;
        self.DEA = 0;
        self.MACD = 0;
    }
}

@end
