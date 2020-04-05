//
//  MTKLine.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/30.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class MTKLinePositionModel;
@interface MTKLine : NSObject
@property (nonatomic, strong) MTKLinePositionModel *positionModel;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end
