//
//  SJKlineModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/18.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJKlineModel : NSObject

#pragma 基础数据
@property (nonatomic, strong) NSNumber *close;          //收盘价
@property (nonatomic, strong) NSNumber *open;           //开盘价
@property (nonatomic, strong) NSNumber *high;           //最高价
@property (nonatomic, strong) NSNumber *low;            //最低价
@property (nonatomic, strong) NSNumber *volume;         //成交量
@property (nonatomic, copy) NSString *date;             //日期

#pragma MA_X
@property (nonatomic, strong) NSNumber *MA_7;           //7个单位的均值（收盘价）
@property (nonatomic, strong) NSNumber *MA_12;          //12个单位的均值（收盘价）
@property (nonatomic, strong) NSNumber *MA_26;          //26个单位的均值（收盘价）
@property (nonatomic, strong) NSNumber *MA_30;          //30个单位的均值（收盘价）

@property (nonatomic, strong) NSNumber *volumeMA_5;     //5个单位的均值（成交量）
@property (nonatomic, strong) NSNumber *volumeMA_10;     //10个单位的均值（成交量）
@property (nonatomic, strong) NSNumber *volumeMA_20;    //20个单位的均值（成交量）

@property (nonatomic, copy) NSNumber *sumOfLastClose;   //该Model及其之前所有收盘价之和
@property (nonatomic, copy) NSNumber *sumOfLastVolume;  //该Model及其之前所有成交量之和

@property (nonatomic, weak) NSArray *mainKLineModels;
@property (nonatomic, weak) SJKlineModel *previousKlineModel;

- (void)initData;

@end
