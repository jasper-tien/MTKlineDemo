//
//  QSCurveBOLL.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSCurveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSCurveBOLL : QSCurveModel

@property (nonatomic, assign) CGFloat MA20;

// 标准差 二次方根【 下的 (n-1)天的 C-MA二次方 和】
@property (nonatomic, assign) CGFloat BOLL_MD;
// n-1 天的 MA
@property (nonatomic, assign) CGFloat BOLL_MB;
// MB + k * MD
@property (nonatomic, assign) CGFloat BOLL_UP;
// MB - k * MD
@property (nonatomic, assign) CGFloat BOLL_DN;
//  n 个 ( Cn - MA20)的平方和
@property (nonatomic, assign) CGFloat BOLL_SUBMD_SUM;
// 当前的 ( Cn - MA20)的平方
@property (nonatomic, assign) CGFloat BOLL_SUBMD;

@end

NS_ASSUME_NONNULL_END
