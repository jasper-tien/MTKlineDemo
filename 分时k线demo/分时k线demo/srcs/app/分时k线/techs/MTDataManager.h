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
@property (nonatomic, copy) NSDictionary *techsDataModelDic;//数据管理池(数据容器)
- (instancetype)initWithArray:(NSArray *)array;
#pragma mark 注入源数据
- (void)inpouringSourceData:(NSArray *)array;

#pragma mark 获取数据
- (NSDictionary *)getDataModelDictionary;
//主k线数据
- (NSArray *)getMainKLineDatas;
- (NSArray *)getMainKLineDatasWithRange:(NSRange)range;
//KDJ数据
- (NSArray *)getKDJDatas;
- (NSArray *)getKDJDatasWithRange:(NSRange)range;
//BOLL数据
- (NSArray *)getBOLLDatas;
- (NSArray *)getBOLLDatasWithRange:(NSRange)range;
//MACD数据
- (NSArray *)getMACDDatas;
- (NSArray *)getMACDDatasWithRange:(NSRange)range;

//根据指标类型获取数据
- (NSArray *)getCurveDatasWithType:(SJCurveTechType)curveTechType;
- (NSArray *)getCurveDatasWithType:(SJCurveTechType)curveTechType range:(NSRange)range;
@end
