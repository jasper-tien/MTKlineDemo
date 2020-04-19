//
//  QSTechBOLLView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class QSCurveBOLL;
@class QSKlineModel;
@interface QSTechBOLLView : QSTechBaseView

@property (nonatomic, copy) NSArray<QSCurveBOLL *> *needDrawBOLLModels;
@property (nonatomic, copy) NSArray<QSKlineModel *> *needDrawBOLLKlineModels;
@property (nonatomic, strong) QSCurveBOLL *showBOLLModel;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
