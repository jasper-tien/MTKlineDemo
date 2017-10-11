//
//  MTCurveBOLL.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/28.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

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
