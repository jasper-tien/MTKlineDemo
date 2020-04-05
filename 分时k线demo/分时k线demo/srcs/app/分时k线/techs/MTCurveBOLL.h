//
//  MTCurveBOLL.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/28.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

//        计算过程：
//        （1）计算MA
//        MA=N日内的收盘价之和÷N
//        （2）计算标准差MD
//        MD=平方根（N-1）日的（C－MA）的两次方之和除以N
//        （3）计算MB、UP、DN线
//        MB=（N－1）日的MA
//        UP=MB+k×MD
//        DN=MB－k×MD
//        （K为参数，可根据股票的特性来做相应的调整，一般默认为2）
//        （N一般选择20天）
#import "MTCurveObject.h"

@interface MTCurveBOLL : MTCurveObject
@property (nonatomic, copy) NSNumber *MA20;

// 标准差 二次方根【 下的 (n-1)天的 C-MA二次方 和】
@property (nonatomic, copy) NSNumber *BOLL_MD;
// n-1 天的 MA
@property (nonatomic, copy) NSNumber *BOLL_MB;
// MB + k * MD
@property (nonatomic, copy) NSNumber *BOLL_UP;
// MB - k * MD
@property (nonatomic, copy) NSNumber *BOLL_DN;
//  n 个 ( Cn - MA20)的平方和
@property (nonatomic, copy) NSNumber *BOLL_SUBMD_SUM;
// 当前的 ( Cn - MA20)的平方
@property (nonatomic, copy) NSNumber *BOLL_SUBMD;

@end
