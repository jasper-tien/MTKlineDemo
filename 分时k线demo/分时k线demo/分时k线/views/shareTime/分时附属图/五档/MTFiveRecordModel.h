//
//  MTFiveRecordModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFiveRecordModel : NSObject
/**
 *  买价格数组
 */
@property (nonatomic, copy) NSArray *BuyPriceArray;

/**
 *  卖价格数组
 */
@property (nonatomic, copy) NSArray *SellPriceArray;

/**
 *  买成交量数组
 */
@property (nonatomic, copy) NSArray *BuyVolumeArray;

/**
 *  卖成交量数组
 */
@property (nonatomic, copy) NSArray *SellVolumeArray;

/**
 *  买5文字描述
 */
@property (nonatomic, copy) NSArray *BuyDescArray;

/**
 *  卖5文字描述
 */
@property (nonatomic, copy) NSArray *SellDescArray;
@end
