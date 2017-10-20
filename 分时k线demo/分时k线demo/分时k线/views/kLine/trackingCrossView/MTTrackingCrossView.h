//
//  MTTrackingCrossView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/17.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTrackingCrossView : UIView
@property (nonatomic, assign) CGPoint crossPoint;
@property (nonatomic, assign) CGRect dateRect;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, assign) CGFloat price;

- (instancetype)initWithFrame:(CGRect)frame crossPoint:(CGPoint)crossPoint dateRect:(CGRect)dateRect;

- (void)updateTrackingCrossView;

@end
