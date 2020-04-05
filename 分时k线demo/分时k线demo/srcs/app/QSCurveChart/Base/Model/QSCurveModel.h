//
//  QSCurveModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseModel.h"
#import "QSConstant.h"
#import "QSKlineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSCurveModel : QSBaseModel
//前一个指标
@property (nonatomic, strong) QSCurveModel *previousCurveObject;
//指标类型
@property (nonatomic, assign) QSCurveTechType curveTechType;

/*
 *  func 子类在此方法中完成指标的计算工作
 *  @baseDatas 请求得到的基础数据
 *  @isFirstTech 是否是第一个数据
 */
- (void)reckonTechWithArray:(NSArray<QSKlineModel *> *)baseDatas container:(NSArray<QSCurveModel *> *)supArray index:(NSInteger)index NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
