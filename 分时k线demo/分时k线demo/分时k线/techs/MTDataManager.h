//
//  MTDataManager.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJCurveChartConstant.h"

@interface MTDataManager : NSObject
@property (nonatomic, copy) NSMutableDictionary *dataModelDictionary;
+ (instancetype)objectWithArray:(NSArray *)array;

- (NSDictionary *)getDataModelDictionary;
- (NSArray *)getMainKLineDatas;
- (NSArray *)getMainKLineDatasWithRange:(NSRange)range;
- (NSArray *)getKDJDatas;
- (NSArray *)getKDJDatasWithRange:(NSRange)range;
- (NSArray *)getCurveDatasWithType:(SJCurveTechType)curveTechType;
@end
