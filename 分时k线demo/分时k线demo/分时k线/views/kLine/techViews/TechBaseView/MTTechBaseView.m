//
//  MTTechBaseView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechBaseView.h"
#import "MTCurveChartGlobalVariable.h"

@implementation MTTechBaseView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentValueMin = 0;
        self.currentValueMax = 0;
        self.currentValueMinToViewY = 0;
        self.currentValueMaxToViewY = self.frame.size.height;
    }
    
    return self;
}

- (void)drawTechView {}
- (void)redrawShowView {}
- (void)redrawShowViewWithIndex:(NSInteger)index{}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition {
    CGFloat xPositoinInMainView = longPressPosition.x;
    CGFloat exactXPositionInMainView = 0.0;
    
    //原始的x位置获取对应在数组中的index
    NSInteger index = xPositoinInMainView / ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    //对应index映射到view上的准确位置
    CGFloat indexXPosition = index * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    //最小临界值
    CGFloat minX = indexXPosition  - ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]) / 2;
    //最大临界值
    CGFloat maxX = indexXPosition + ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]) / 2;
    //对比原始x值大于最小临界值，并小于最大临界值，返回当前index的精确位置;当大于最大临界值时，返回下一个index对应的精确位置(理论上该值不可能小于最小临界值，所以不用考虑)
    if (xPositoinInMainView < maxX && xPositoinInMainView > minX) {
        exactXPositionInMainView = indexXPosition;
    } else {
        index++;
        exactXPositionInMainView = indexXPosition + ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(techBaseViewLongPressExactPosition:UnitY:)]) {
        [self.delegate techBaseViewLongPressExactPosition:CGPointMake(exactXPositionInMainView, longPressPosition.y) UnitY:self.unitValue];
    }
}


@end
