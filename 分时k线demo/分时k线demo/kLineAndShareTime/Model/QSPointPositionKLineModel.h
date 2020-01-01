//
//  QSPointPositionKLineModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSPointPositionKLineModel : QSBaseModel

@property (nonatomic, assign) CGPoint openPoint;    /// 开盘点
@property (nonatomic, assign) CGPoint closePoint;   /// 收盘点
@property (nonatomic, assign) CGPoint highPoint;    /// 最高点
@property (nonatomic, assign) CGPoint lowPoint;     /// 最低点

@end

NS_ASSUME_NONNULL_END
