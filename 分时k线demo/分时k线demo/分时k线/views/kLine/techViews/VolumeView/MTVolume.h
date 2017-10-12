//
//  MTVolume.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MTVolumePositionModel.h"

@interface MTVolume : NSObject
@property (nonatomic, strong) MTVolumePositionModel *positionModel;
- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;
@end
