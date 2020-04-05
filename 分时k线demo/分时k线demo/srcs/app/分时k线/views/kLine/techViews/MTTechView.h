//
//  MTTechView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/11.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJCurveChartConstant.h"

@protocol MTTechViewDelegate<NSObject>
- (void)techViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressValue:(CGFloat)longPressValue;
@end

@interface MTTechView : UIView
@property (nonatomic, copy) NSArray *needDrawTechModels;
@property (nonatomic, copy) NSArray *needDrawKlineModels;
@property (nonatomic, weak) id<MTTechViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawTechViewWithType:(SJCurveTechType)techType;
//重绘最新或者长按选定的数据
- (void)reDrawTechShowViewWithIndex:(NSInteger)index;
//长按，或者移动时调用
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;

@end
