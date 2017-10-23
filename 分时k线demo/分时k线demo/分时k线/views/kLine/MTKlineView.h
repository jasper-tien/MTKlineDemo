//
//  MTKlineView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/10.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDataManager.h"
#import "SJCurveChartConstant.h"

@interface MTKlineView : UIView

@property (nonatomic, strong) MTDataManager *manager;
@property (nonatomic, assign) SJKlineType kLineType;

- (instancetype)initWithFrame:(CGRect)frame;
@end
