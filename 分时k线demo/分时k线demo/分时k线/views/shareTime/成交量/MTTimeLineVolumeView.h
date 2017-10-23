//
//  MTTimeLineVolumeView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTTimeLineModel;
@interface MTTimeLineVolumeView : UIView
@property (nonatomic, copy) NSArray<MTTimeLineModel *> *needDrawVolumeModels;
- (void)updateDrawModels;
@end
