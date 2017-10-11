//
//  SJManageDataToModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/19.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//
// 源数据处理类
#import <Foundation/Foundation.h>
#import "SJCurveChartConstant.h"

@class SJCurveManager;
@interface SJManageDataToModel : NSObject
@property (nonatomic, copy) NSMutableDictionary *dataModelDictionary;
+ (instancetype)objectWithArray:(NSArray *)array;

- (NSDictionary *)getDataModelDictionary;
- (SJCurveManager *)getMainKLineDatas;
- (SJCurveManager *)getVolumeDatas;
- (SJCurveManager *)getCurveDatasWithType:(SJCurveTechType)curveTechType;

@end
