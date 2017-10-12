//
//  MTTechVolumeView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechBaseView.h"

@class SJKlineModel;
@interface MTTechVolumeView : MTTechBaseView
//成交量model暂时包含于k蜡烛model
@property (nonatomic, copy) NSArray<SJKlineModel *> *needDrawVolumeModels;
- (instancetype)initWithFrame:(CGRect)frame;

@end
