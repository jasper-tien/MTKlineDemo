//
//  QSCurveBOLL.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSCurveBOLL.h"
#import "QSKlineModel.h"

@implementation QSCurveBOLL

- (instancetype)init {
    if (self = [super init]) {
        self.curveTechType = QSCurveTechType_BOLL;
    }
    return self;
}

- (void)reckonTechWithArray:(NSArray<QSKlineModel *> *)baseDatas container:(NSArray<QSCurveModel *> *)supArray index:(NSInteger)index {
    [super reckonTechWithArray:baseDatas container:supArray index:index];
    //在此方法中计算指标
    QSKlineModel *model = baseDatas[index];
    if (index >= 19) {
        if (index > 19) {
            self.MA20 = (model.sumOfLastClose - baseDatas[index - 19].sumOfLastClose) / 19;
            
        } else {
            self.MA20 = model.sumOfLastClose / index;
        }
        
        if (index >= 20) {
            self.BOLL_SUBMD = (model.close - self.MA20) * ( model.close - self.MA20);
            QSCurveBOLL *previousCurveObject = (QSCurveBOLL *)supArray[index - 1];
            self.BOLL_SUBMD_SUM = previousCurveObject.BOLL_SUBMD_SUM + self.BOLL_SUBMD;
            QSCurveBOLL *curveObject20 = (QSCurveBOLL *)supArray[index - 20];
            self.BOLL_MD = sqrt((previousCurveObject.BOLL_SUBMD_SUM - curveObject20.BOLL_SUBMD_SUM)/ 20);
            self.BOLL_MB = model.MA_30;
            self.BOLL_UP = self.BOLL_MB + 2 * self.BOLL_MD;
            self.BOLL_DN = self.BOLL_MB - 2 * self.BOLL_MD;
        }
    }
}

@end
