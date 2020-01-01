//
//  QSMainKLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QSPointKLineModel;
@interface QSMainKLineView : UIView

- (instancetype)initWithViewModel:(QSPointKLineModel *)viewModel;
- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSPointKLineModel *)viewModel;
- (void)bindVM:(QSPointKLineModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
