//
//  QSTrackingCrossVM.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/11/29.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrackingCrossVM.h"

@implementation QSTrackingCrossVM

#pragma mark - QSTrendViewModelCastProtocol

- (void)m_castNeedUpdateIfNeed {
    NSLog(@"QSTrendKLineVM m_castNeedUpdateIfNeed");
}

- (void)m_castLongPress:(QSPressTriggerPosition)postion selectedIndex:(NSInteger)index xPoint:(CGFloat)xPoint yPoint:(CGFloat)yPoint xValue:(CGFloat)xValue yValue:(CGFloat)yValue {
    if (postion == QSPressTriggerPositionTech) {
        
    } else if (postion == QSPressTriggerPositionKLine) {
        self.showValue = yValue;
        self.crossPoint = CGPointMake(xPoint, yPoint);
    }
}

@end
