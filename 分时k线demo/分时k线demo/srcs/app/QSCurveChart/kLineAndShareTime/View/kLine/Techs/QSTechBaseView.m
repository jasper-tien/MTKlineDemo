//
//  QSTechBaseView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechBaseView.h"
#import "QSCurveChartGlobalVariable.h"

@implementation QSTechBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentValueMin = 0;
        self.currentValueMax = 0;
        self.currentValueMinToViewY = 0;
        self.currentValueMaxToViewY = 150;
    }
    
    return self;
}

- (void)drawTechView {}
- (void)redrawShowView {}
- (void)reDrawShowViewWithIndex:(NSInteger)index{}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition {
    CGFloat xPositoinInMainView = longPressPosition.x;
    CGFloat exactXPositionInMainView = 0.0;
    
    //原始的x位置获取对应在数组中的index
    NSInteger index = xPositoinInMainView / ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
    //对应index映射到view上的准确位置
    CGFloat indexXPosition = index * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
    //最小临界值
    CGFloat minX = indexXPosition  - ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]) / 2;
    //最大临界值
    CGFloat maxX = indexXPosition + ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]) / 2;
    //对比原始x值大于最小临界值，并小于最大临界值，返回当前index的精确位置;当大于最大临界值时，返回下一个index对应的精确位置(理论上该值不可能小于最小临界值，所以不用考虑)
    if (xPositoinInMainView < maxX && xPositoinInMainView > minX) {
        exactXPositionInMainView = indexXPosition;
    } else {
        index++;
        exactXPositionInMainView = indexXPosition + ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
    }
    
    [self reDrawShowViewWithIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(techBaseViewLongPressExactPosition:selectedIndex:longPressValue:)]) {
        CGFloat longPressValue = self.unitValue * (self.currentValueMaxToViewY - longPressPosition.y) + self.currentValueMin;
        if (longPressValue < self.currentValueMin) {
            longPressValue = self.currentValueMin;
        }
        [self.delegate techBaseViewLongPressExactPosition:CGPointMake(exactXPositionInMainView, longPressPosition.y) selectedIndex:index longPressValue:longPressValue];
    }
}
@end
