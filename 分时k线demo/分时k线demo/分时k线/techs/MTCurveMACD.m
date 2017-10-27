//
//  MTCurveMACD.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTCurveMACD.h"
#import "SJKlineModel.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation MTCurveMACD
- (instancetype)init {
    if (self = [super init]) {
        self.curveTechType = SJCurveTechType_MACD;
    }
    
    return self;
}

-(void)reckonTechWithArray:(NSArray<SJKlineModel *> *)baseDatas container:(NSArray<MTCurveObject *> *)supArray index:(NSInteger)index {
    [super reckonTechWithArray:baseDatas container:supArray index:index];
    //在此方法中计算指标
    SJKlineModel *model = baseDatas[index];
    if (index > 0) {
        MTCurveMACD *previousCurveMACD = (MTCurveMACD *)supArray[index - 1];
        self.EMA12 = @(previousCurveMACD.EMA12.floatValue * 11 / 13 + model.close.floatValue * 2 / 13);
        self.EMA26 = @(previousCurveMACD.EMA26.floatValue * 25 / 27 + model.close.floatValue * 2 / 27);
        self.DIF = @(self.EMA12.floatValue - self.EMA26.floatValue);
        CGFloat previousDEA = 0;
        if (previousCurveMACD.DEA.floatValue != MTCurveChartFloatMax) {
            previousDEA = previousCurveMACD.DEA.floatValue;
        }
        self.DEA = @(previousDEA * 8 / 10 + self.DIF.floatValue * 2 / 10);
        self.MACD = @(2 * (self.DIF.floatValue - self.DEA.floatValue));
    } else {
        self.EMA12 = model.close;
        self.EMA26 = model.close;
        self.DIF = @(MTCurveChartFloatMax);
        self.DEA = @(MTCurveChartFloatMax);
        self.MACD = @(MTCurveChartFloatMax);
    }
}
@end
