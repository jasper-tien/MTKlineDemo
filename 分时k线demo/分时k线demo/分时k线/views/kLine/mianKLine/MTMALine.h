//
//  MTMALine.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/10.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MTMAType){
    MT_MA7Type = 0,
    MT_MA30Type,
    MT_BOLL_MB,
    MT_BOLL_UP,
    MT_BOLL_DN
};

@interface MTMALine : NSObject
@property (nonatomic, strong) NSArray *MAPositions;
@property (nonatomic, assign) MTMAType MAType;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;
@end
