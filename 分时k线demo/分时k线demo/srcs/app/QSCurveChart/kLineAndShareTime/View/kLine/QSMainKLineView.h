//
//  QSMainKLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QSMainKLineViewDelegate<NSObject>
/**
 *  长按
 */
- (void)kLineMainViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressPrice:(CGFloat)price;

@end

@class QSTrendKLineVM;
@interface QSMainKLineView : UIView

@property (nonatomic, weak) id<QSMainKLineViewDelegate> delegate;

- (instancetype)initWithViewModel:(QSTrendKLineVM *)viewModel;
- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendKLineVM *)viewModel;
- (void)bindVM:(QSTrendKLineVM *)viewModel;

- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;
- (void)reDrawShowViewWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
