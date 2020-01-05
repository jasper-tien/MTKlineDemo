//
//  QSCurveKDJ.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSCurveKDJ.h"
#import "QSKlineModel.h"

@implementation QSCurveKDJ

- (instancetype)init {
    if (self = [super init]) {
        self.curveTechType = QSCurveTechType_KDJ;
    }
    return self;
}

- (void)reckonTechWithArray:(NSArray<QSKlineModel *> *)baseDatas container:(NSArray<QSCurveModel *> *)supArray index:(NSInteger)index {
    [super reckonTechWithArray:baseDatas container:supArray index:index];
    //在此方法中计算指标
    QSKlineModel *model = baseDatas[index];
    self.nineClocksMinPrice = model.low;
    self.nineClocksMaxPrice = model.high;
    if (index > 0) {
        NSInteger maxCount = index;
        if (index >= 8) {
            maxCount = 9;
        }
        NSInteger count = index;
        for (NSInteger i = 0 ; i < maxCount; i++) {
            if (self.nineClocksMaxPrice < baseDatas[count].high) {
                self.nineClocksMaxPrice = baseDatas[count].high;
            }
            if (self.nineClocksMinPrice > baseDatas[count].low) {
                self.nineClocksMinPrice = baseDatas[count].low;
            }
            count--;
        }
    }
    self.RSV_9 = (model.close - self.nineClocksMinPrice) / (self.nineClocksMaxPrice - self.nineClocksMinPrice) * 100;
    //第一天的K，D通常初始化为50
    if (index == 0) {
        self.KDJ_D = 50;
        self.KDJ_K = 50;
        
    } else {
        QSCurveKDJ *previousCurveKDJ = (QSCurveKDJ *)supArray[index - 1];
        self.KDJ_D = (self.RSV_9 + 2 * previousCurveKDJ.KDJ_K) / 3;
        self.KDJ_K = (self.KDJ_K + 2 * previousCurveKDJ.KDJ_D) / 3;
    }
    self.KDJ_J = 3 * self.KDJ_K - 2 * self.KDJ_D;
}

@end
