//
//  QSTechMACDView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class QSCurveMACD;
@interface QSTechMACDView : QSTechBaseView

@property (nonatomic, copy) NSArray<QSCurveMACD *> *needDrawMACDModels;
@property (nonatomic, strong) QSCurveMACD *showMACDModel;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
