//
//  QSKLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/5.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QSTrendViewModel;
@interface QSKLineView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
