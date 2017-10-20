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
- (void)techViewLongPressExactPosition:(CGPoint)longPressPosition UnitY:(CGFloat)unitY;
@end

@interface MTTechView : UIView
@property (nonatomic, copy) NSArray *needDrawTechModels;
@property (nonatomic, copy) NSArray *needDrawKlineModels;
@property (nonatomic, weak) id<MTTechViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawTechViewWithType:(SJCurveTechType)techType;
- (void)redrawTechShowViewWithIndex:(NSInteger)index;
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;

@end
