//
//  MTTechBaseView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJCurveChartConstant.h"

@interface MTTechBaseView : UIView
@property (nonatomic, assign) SJCurveTechType techType;
- (void)drawTechView;
- (void)redrawShowViewWithIndex:(NSInteger)index;

@end
