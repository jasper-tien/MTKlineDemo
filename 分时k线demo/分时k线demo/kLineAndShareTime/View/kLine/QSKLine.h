//
//  QSKLine.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class QSPointPositionKLineModel;
@interface QSKLine : NSObject

@property (nonatomic, strong) QSPointPositionKLineModel *positionModel;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end

NS_ASSUME_NONNULL_END
