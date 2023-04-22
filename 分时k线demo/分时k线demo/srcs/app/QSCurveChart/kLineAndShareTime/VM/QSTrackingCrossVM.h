//
//  QSTrackingCrossVM.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/11/29.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewModel.h"
#import "QSTrendViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSTrackingCrossVM : QSBaseViewModel<QSTrendViewModelCastProtocol>

@property (nonatomic, assign) CGPoint crossPoint;
@property (nonatomic, assign) CGRect dateRect;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, assign) CGFloat showValue;

@end

NS_ASSUME_NONNULL_END
