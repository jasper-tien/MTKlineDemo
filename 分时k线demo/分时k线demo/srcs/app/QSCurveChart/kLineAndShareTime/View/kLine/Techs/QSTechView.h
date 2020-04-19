//
//  QSTechView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSConstant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QSTechViewDelegate<NSObject>
- (void)techViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressValue:(CGFloat)longPressValue;
@end

@interface QSTechView : UIView

@property (nonatomic, copy) NSArray *needDrawTechModels;
@property (nonatomic, copy) NSArray *needDrawKlineModels;
@property (nonatomic, weak) id<QSTechViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawTechViewWithType:(QSCurveTechType)techType;
//重绘最新或者长按选定的数据
- (void)reDrawTechShowViewWithIndex:(NSInteger)index;
//长按，或者移动时调用
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;

@end

NS_ASSUME_NONNULL_END
