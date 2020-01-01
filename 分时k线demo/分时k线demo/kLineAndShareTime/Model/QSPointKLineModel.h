//
//  QSPointKLineModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSPointKLineModel : QSBaseModel
@property (nonatomic, assign) CGFloat open;     /// 开盘价
@property (nonatomic, assign) CGFloat high;     /// 最高价
@property (nonatomic, assign) CGFloat low;      /// 最低价
@property (nonatomic, assign) CGFloat close;    /// 收盘价
@property (nonatomic, assign) CGFloat volume;   /// 成交量
@property (nonatomic, copy) NSString *time;     /// 日期
@end

NS_ASSUME_NONNULL_END
