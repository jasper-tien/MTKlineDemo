//
//  MTCurveMACD.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTCurveObject.h"

@interface MTCurveMACD : MTCurveObject
//关键的一点是：新股上市首日，其DIFF,DEA以及MACD都为0，因为当日不存在前一日，无法做迭代。而计算新股上市第二日的EMA时，前一日的EMA需要用收盘价（而非0）来计算。另外，需要注意，计算过程小数点后四舍五入保留4位小数，最后显示的时候四舍五入保留3位小数。
//具体计算公式及例子如下：
//EMA（12）= 前一日EMA（12）×11/13＋今日收盘价×2/13
//EMA（26）= 前一日EMA（26）×25/27＋今日收盘价×2/27
//DIFF=今日EMA（12）- 今日EMA（26）
//DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
//BAR=2×(DIFF－DEA)

@property (nonatomic, copy) NSNumber *EMA12;

@property (nonatomic, copy) NSNumber *EMA26;

@property (nonatomic, copy) NSNumber *DIF;

@property (nonatomic, copy) NSNumber *DEA;

@property (nonatomic, copy) NSNumber *MACD;

@end
