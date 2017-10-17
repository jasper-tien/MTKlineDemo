//
//  MTTechBOLLView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechBaseView.h"

@class MTCurveBOLL;
@class SJKlineModel;
@interface MTTechBOLLView : MTTechBaseView
@property (nonatomic, copy) NSArray<MTCurveBOLL *> *needDrawBOLLModels;
@property (nonatomic, copy) NSArray<SJKlineModel *> *needDrawBOLLKlineModels;
@property (nonatomic, strong) MTCurveBOLL *showBOLLModel;
- (instancetype)initWithFrame:(CGRect)frame;
@end
