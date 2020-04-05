//
//  MTFenShiView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTFenShiViewDataSource<NSObject>

@end

@class MTTimeLineModel;
@interface MTFenShiView : UIView
@property (nonatomic, copy) NSArray<MTTimeLineModel *> *timeLineModels;
- (void)updateDrawTimeLine;
@end
