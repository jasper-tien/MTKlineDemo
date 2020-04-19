//
//  QSTechVolumeView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class QSKlineModel;
@interface QSTechVolumeView : QSTechBaseView
//成交量model暂时包含于k蜡烛model
@property (nonatomic, copy) NSArray<QSKlineModel *> *needDrawVolumeModels;

@property (nonatomic, strong) QSKlineModel *showKlineModel;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
