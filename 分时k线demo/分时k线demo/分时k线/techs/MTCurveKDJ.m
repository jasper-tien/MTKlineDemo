//
//  MTCurveKDJ.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/28.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTCurveKDJ.h"
#import "SJKlineModel.h"

@implementation MTCurveKDJ
- (instancetype)init {
    if (self = [super init]) {
        self.curveTechType = SJCurveTechType_KDJ;
    }
    return self;
}
- (void)reckonTechWithArray:(NSArray<SJKlineModel *> *)baseDatas container:(NSArray<MTCurveObject *> *)supArray index:(NSInteger)index {
    [super reckonTechWithArray:baseDatas container:supArray index:index];
    //在此方法中计算指标
    SJKlineModel *model = baseDatas[index];
    self.nineClocksMinPrice = model.low;
    self.nineClocksMaxPrice = model.high;
    if (index > 0) {
        NSInteger maxCount = index;
        if (index >= 8) {
            maxCount = 9;
        }
        NSInteger count = index;
        for (NSInteger i = 0 ; i < maxCount; i++) {
            if ([self.nineClocksMaxPrice compare:baseDatas[count].high] == NSOrderedAscending) {
                self.nineClocksMaxPrice = @([baseDatas[count].high floatValue]);
            }
            if ([self.nineClocksMinPrice compare:baseDatas[count].low] == NSOrderedDescending) {
                self.nineClocksMinPrice = @([baseDatas[count].low floatValue]);
            }
            count--;
        }
    }
    self.RSV_9 = @((model.close.floatValue - self.nineClocksMinPrice.floatValue) / (self.nineClocksMaxPrice.floatValue - self.nineClocksMinPrice.floatValue) * 100);
    //第一天的K，D通常初始化为50
    if (index == 0) {
        self.KDJ_D = @50;
        self.KDJ_K = @50;
        
    } else {
        MTCurveKDJ *previousCurveKDJ = (MTCurveKDJ *)supArray[index - 1];
        self.KDJ_D = @((self.RSV_9.floatValue + 2 * previousCurveKDJ.KDJ_K.floatValue) / 3);
        self.KDJ_K = @((self.KDJ_K.floatValue + 2 * previousCurveKDJ.KDJ_D.floatValue) / 3);
    }
    self.KDJ_J = @(3 * self.KDJ_K.floatValue - 2 * self.KDJ_D.floatValue);
}

@end
