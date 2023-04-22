//
//  QSCurveStatus.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/11/29.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QSCurveScreenState) {
    QSCurveScreenStateNone,
    QSCurveScreenStateVertical = 1 >> 0,        // 竖屏
    QSCurveScreenStateHorizontal = 1 >> 1,      // 横屏
    QSCurveScreenStateFull = 1 >> 2,            // 全屏
    QSCurveScreenStateVerticalFull = QSCurveScreenStateVertical | QSCurveScreenStateFull,
    QSCurveScreenStateHorizontalFull = QSCurveScreenStateHorizontal | QSCurveScreenStateFull,
};

@interface QSCurveStatus : NSObject

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) QSCurveScreenState *screenState;

@end

NS_ASSUME_NONNULL_END
