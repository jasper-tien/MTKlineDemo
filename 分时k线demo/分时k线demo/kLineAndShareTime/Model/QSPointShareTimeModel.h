//
//  QSPointShareTimeModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSPointShareTimeModel : QSBaseModel
@property (nonatomic, assign) CGFloat price;                /// 价格
@property (nonatomic, assign) CGFloat preClosePrice;        /// 前一天的收盘价
@property (nonatomic, assign) CGFloat volume;               /// 成交量
@property (nonatomic, copy) NSString *time;                 /// 日期
@end

NS_ASSUME_NONNULL_END
