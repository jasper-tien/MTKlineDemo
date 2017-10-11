//
//  MTKLinePositionModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/9.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKLinePositionModel : NSObject
/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint openPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint highPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint lowPoint;

@end
