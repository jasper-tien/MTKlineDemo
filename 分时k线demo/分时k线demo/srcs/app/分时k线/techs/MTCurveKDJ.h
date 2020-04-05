//
//  MTCurveKDJ.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/28.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

//KDJ(9,3.3),下面以该参数为例说明计算方法。
//9，3，3代表指标分析周期为9天，K值D值为3天
//RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
//K(3日)=（当日RSV值+2*前一日K值）÷3
//D(3日)=（当日K值+2*前一日D值）÷3
//J=3K－2D
#import "MTCurveObject.h"

@interface MTCurveKDJ : MTCurveObject

//9Clock内最低价
@property (nonatomic, copy) NSNumber *nineClocksMinPrice;
//9Clock内最高价
@property (nonatomic, copy) NSNumber *nineClocksMaxPrice;

@property (nonatomic, copy) NSNumber *RSV_9;

@property (nonatomic, copy) NSNumber *KDJ_K;

@property (nonatomic, copy) NSNumber *KDJ_D;

@property (nonatomic, copy) NSNumber *KDJ_J;

@end
