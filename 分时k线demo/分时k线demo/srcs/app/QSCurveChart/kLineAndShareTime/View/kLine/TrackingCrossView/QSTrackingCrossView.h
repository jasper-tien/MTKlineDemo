//
//  QSTrackingCrossView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/5.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSTrackingCrossVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSTrackingCrossView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateTrackingCrossView;

- (void)bindVM:(QSTrackingCrossVM *)trackingCrossVM;

@end

NS_ASSUME_NONNULL_END
