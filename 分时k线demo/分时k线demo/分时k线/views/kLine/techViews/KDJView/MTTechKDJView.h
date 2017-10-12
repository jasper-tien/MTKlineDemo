//
//  MTTechKDJView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechBaseView.h"

@class MTCurveKDJ;
@interface MTTechKDJView : MTTechBaseView
@property (nonatomic, copy) NSArray<MTCurveKDJ *> *needDrawKDJModels;
- (instancetype)initWithFrame:(CGRect)frame;
@end
