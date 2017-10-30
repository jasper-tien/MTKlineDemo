//
//  MTTimeLineTrackingCrossView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTimeLineTrackingCrossView : UIView
@property (nonatomic, assign) CGPoint crossPoint;
@property (nonatomic, assign) CGFloat showValue;
@property (nonatomic, assign) CGFloat maxPointX;
@property (nonatomic, assign) CGFloat minPointX;

- (instancetype)initWithFrame:(CGRect)frame crossPoint:(CGPoint)crossPoint;

- (void)updateTrackingCrossView;
@end
