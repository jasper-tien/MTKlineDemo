//
//  QSTrendViewModelProtocol.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/11/22.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSConstant.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QSTrendViewModelProtocol <NSObject>

/// test

- (void)pritfTestLog;

@end

@protocol QSTrendViewModelCastProtocol <NSObject>

@optional

- (void)m_castNeedUpdateIfNeed;

- (void)m_castLongPress:(QSPressTriggerPosition)postion selectedIndex:(NSInteger)index xPoint:(CGFloat)xPoint yPoint:(CGFloat)yPoint xValue:(CGFloat)xValue yValue:(CGFloat)yValue;

@end

NS_ASSUME_NONNULL_END
