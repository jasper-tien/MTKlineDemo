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
- (void)kLineMainViewLongPress:(NSInteger)index exactPosition:(CGPoint)longPressPosition longPressPrice:(CGFloat)price;

@end

@interface MTMianKLineView : UIView

@property (nonatomic, weak) id<MTMianKLineViewDelegate> delegate;
//
@property (nonatomic, copy) NSArray<SJKlineModel *> *needDrawKlneModels;
//
@property (nonatomic, strong) SJKlineModel *showKlineModel;

- (instancetype)initWithDelegate:(id<MTMianKLineViewDelegate>)delegate;

- (void)drawMainView;

- (void)getExactPositionWithOriginPosition:(CGPoint)longPressPosition;

@end
