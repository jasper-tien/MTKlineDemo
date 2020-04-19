//
//  QSVolume.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "QSVolumePositionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSVolume : NSObject

@property (nonatomic, strong) QSVolumePositionModel *positionModel;
- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end

NS_ASSUME_NONNULL_END
