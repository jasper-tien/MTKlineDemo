//
//  MTMianKLineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/30.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDataManager.h"
@protocol MTMianKLineViewDelegate<NSObject>

@end

@class SJKlineModel;
@interface MTMianKLineView : UIView
//
@property (nonatomic, weak) id<MTMianKLineViewDelegate> delegate;
//
@property (nonatomic, copy) NSArray<SJKlineModel *> *needDrawKlneModels;

- (instancetype)initWithDelegate:(id<MTMianKLineViewDelegate>)delegate;

- (void)drawMainView;

@end
