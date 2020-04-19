//
//  QSTechBaseView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSConstant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QSTechBaseViewDelegate<NSObject>
- (void)techBaseViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressValue:(CGFloat)longPressValue;

@end

@interface QSTechBaseView : UIView

@property (nonatomic, assign) QSCurveTechType techType;
@property (nonatomic, weak) id<QSTechBaseViewDelegate> delegate;
//视图view上单位距离对应的数值
@property (nonatomic, assign) CGFloat unitValue;
// 当前最大值
@property (nonatomic, assign) CGFloat currentValueMax;
// 当前最小值
@property (nonatomic, assign) CGFloat currentValueMin;
//当前最大值对应到视图上的纵坐标
@property (nonatomic, assign) CGFloat currentValueMaxToViewY;
//当前最小值对应到视图上的纵坐标
@property (nonatomic, assign) CGFloat currentValueMinToViewY;
- (void)drawTechView;
//在指标view的顶部画最新的数据或者选定的数据
- (void)reDrawShowViewWithIndex:(NSInteger)index;
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;

@end

NS_ASSUME_NONNULL_END
