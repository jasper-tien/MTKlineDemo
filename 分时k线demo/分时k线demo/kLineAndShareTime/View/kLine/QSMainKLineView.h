//
//  QSMainKLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QSTrendKLineVM;
@interface QSMainKLineView : UIView

- (instancetype)initWithViewModel:(QSTrendKLineVM *)viewModel;
- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendKLineVM *)viewModel;
- (void)bindVM:(QSTrendKLineVM *)viewModel;

@end

NS_ASSUME_NONNULL_END
