//
//  QSTechKDJView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class QSCurveKDJ;
@interface QSTechKDJView : QSTechBaseView

@property (nonatomic, copy) NSArray<QSCurveKDJ *> *needDrawKDJModels;
@property (nonatomic, strong) QSCurveKDJ *showKDJModel;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
