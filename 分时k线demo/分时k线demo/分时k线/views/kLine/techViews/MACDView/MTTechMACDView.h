//
//  MTTechMACDView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/13.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechBaseView.h"

@class MTCurveMACD;
@interface MTTechMACDView : MTTechBaseView
@property (nonatomic, copy) NSArray<MTCurveMACD *> *needDrawMACDModels;
- (instancetype)initWithFrame:(CGRect)frame;
@end
