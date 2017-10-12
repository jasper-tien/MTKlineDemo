//
//  MTTechView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/11.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJCurveChartConstant.h"

@interface MTTechView : UIView
@property (nonatomic, copy) NSArray *needDrawTechModels;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawTechViewWithType:(SJCurveTechType)techType;
@end
