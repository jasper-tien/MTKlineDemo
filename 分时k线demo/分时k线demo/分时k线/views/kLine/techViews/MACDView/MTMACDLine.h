//
//  MTMACDLine.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/13.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMACDLine : NSObject
@property (nonatomic, strong) NSArray *MACDPositions;
@property (nonatomic, assign) CGFloat zeroPointY;
- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;
@end
