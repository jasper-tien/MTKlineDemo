//
//  MTTimeLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTTimeLineViewDelegate<NSObject>
/**
 *  长按
 */
- (void)timeLineViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressPrice:(CGFloat)price;

@end

@class MTTimeLineModel;
@interface MTTimeLineView : UIView
@property (nonatomic, copy) NSArray<MTTimeLineModel *> *timeLineModels;
@property (nonatomic, weak) id<MTTimeLineViewDelegate> delegate;

/**
 更新需要绘制的数据源
 */
- (void)updateDrawModels;

- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;
@end
