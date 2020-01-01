//
//  QSKlineModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSKlineModel : QSBaseModel
#pragma 基础数据
@property (nonatomic, assign) CGFloat close;          //收盘价
@property (nonatomic, assign) CGFloat open;           //开盘价
@property (nonatomic, assign) CGFloat high;           //最高价
@property (nonatomic, assign) CGFloat low;            //最低价
@property (nonatomic, assign) CGFloat volume;         //成交量
@property (nonatomic, copy) NSString *date;             //日期

#pragma MA_X
@property (nonatomic, assign) CGFloat MA_5;           //7个单位的均值（收盘价）
@property (nonatomic, assign) CGFloat MA_10;          //12个单位的均值（收盘价）
@property (nonatomic, assign) CGFloat MA_20;          //26个单位的均值（收盘价）
@property (nonatomic, assign) CGFloat MA_30;          //30个单位的均值（收盘价）

@property (nonatomic, assign) CGFloat volumeMA_5;     //5个单位的均值（成交量）
@property (nonatomic, assign) CGFloat volumeMA_10;     //10个单位的均值（成交量）
@property (nonatomic, assign) CGFloat volumeMA_20;    //20个单位的均值（成交量）

@property (nonatomic, assign) CGFloat sumOfLastClose;   //该Model及其之前所有收盘价之和
@property (nonatomic, assign) CGFloat sumOfLastVolume;  //该Model及其之前所有成交量之和

@property (nonatomic, weak) NSArray *mainKLineModels;
@property (nonatomic, weak) QSKlineModel *previousKlineModel;

- (void)initData;

@end

NS_ASSUME_NONNULL_END
