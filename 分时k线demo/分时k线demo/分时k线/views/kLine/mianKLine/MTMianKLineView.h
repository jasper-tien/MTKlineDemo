//
//  MTMianKLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/30.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDataManager.h"
@class SJKlineModel;
@protocol MTMianKLineViewDelegate<NSObject>
/**
 *  长按
 */
- (void)kLineMainViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressPrice:(CGFloat)price;

@end

@interface MTMianKLineView : UIView

@property (nonatomic, weak) id<MTMianKLineViewDelegate> delegate;
//
@property (nonatomic, copy) NSArray<SJKlineModel *> *needDrawKlneModels;
//需要显示在顶部的model
@property (nonatomic, strong) SJKlineModel *showKlineModel;

- (instancetype)initWithDelegate:(id<MTMianKLineViewDelegate>)delegate;

- (void)drawMainView;

- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;

//重绘最新的数据或者选定的数据
- (void)reDrawShowViewWithIndex:(NSInteger)index;

@end
