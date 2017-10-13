//
//  MTBOLLUSALine.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/13.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MTKLinePositionModel;
@interface MTBOLLUSALine : NSObject
@property (nonatomic, strong) MTKLinePositionModel *positionModel;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;
@end
