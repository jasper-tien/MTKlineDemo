//
//  MTTimeLineModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MTTimeLineModel : NSObject
/**
 *  价格
 */
@property (nonatomic, strong) NSNumber *Price;

/**
 *  前一天的收盘价
 */
@property (nonatomic, assign) CGFloat previousClosePrice;

/**
 *  成交量
 */
@property (nonatomic, assign) CGFloat Volume;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *TimeDesc;
@end
