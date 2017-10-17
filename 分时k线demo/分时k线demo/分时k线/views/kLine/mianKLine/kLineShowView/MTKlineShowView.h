//
//  MTKlineShowView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/17.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKlineShowView : UIView
@property (nonatomic, copy) NSString *titleStr;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)redrawWithString:(NSString *)string;
@end
