//
//  QSMainShareTimeView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QSTrendShareTimeVM;
@interface QSMainShareTimeView : UIView

- (instancetype)initWithViewModel:(QSTrendShareTimeVM *)viewModel;
- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendShareTimeVM *)viewModel;
- (void)bindVM:(QSTrendShareTimeVM *)viewModel;

@end

NS_ASSUME_NONNULL_END
