//
//  MTCurveObject.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJCurveChartConstant.h"
@class SJKlineModel;
@interface MTCurveObject : NSObject
/**
 *  前一个指标
 */
@property (nonatomic, strong) MTCurveObject *previousCurveObject;
@property (nonatomic, assign) SJCurveTechType curveTechType;

#pragma mark -
/*
 *  func 子类在此方法中完成指标的计算工作
 *  @baseDatas 请求得到的基础数据
 *  @isFirstTech 是否是第一个数据
 */
- (void)reckonTechWithArray:(NSArray<SJKlineModel *> *)baseDatas container:(NSArray<MTCurveObject *> *)supArray index:(NSInteger)index NS_REQUIRES_SUPER;

@end
