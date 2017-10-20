//
//  MTTechBaseView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJCurveChartConstant.h"

@protocol MTTechBaseViewDelegate<NSObject>
- (void)techBaseViewLongPressExactPosition:(CGPoint)longPressPosition UnitY:(CGFloat)unitY;

@end

@interface MTTechBaseView : UIView
@property (nonatomic, assign) SJCurveTechType techType;
@property (nonatomic, weak) id<MTTechBaseViewDelegate> delegate;
@property (nonatomic, assign) CGFloat unitValue;
- (void)drawTechView;
//在指标view的顶部画最新的数据或者选定的数据
- (void)redrawShowViewWithIndex:(NSInteger)index;
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;
@end
