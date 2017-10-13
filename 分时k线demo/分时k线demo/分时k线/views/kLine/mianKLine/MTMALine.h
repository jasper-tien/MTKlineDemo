//
//  MTMALine.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/10.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJCurveChartConstant.h"
typedef NS_ENUM(NSInteger, MTMAType){
    MT_MA5Type = 0,
    MT_MA7Type,
    MT_MA10Type,
    MT_MA20Type,
    MT_MA30Type,
    MT_BOLL_MB,
    MT_BOLL_UP,
    MT_BOLL_DN,
    MT_KDJ_K,
    MT_KDJ_D,
    MT_KDJ_J,
};

@interface MTMALine : NSObject
@property (nonatomic, strong) NSArray *MAPositions;
@property (nonatomic, assign) MTMAType MAType;
@property (nonatomic, assign) SJCurveTechType techType;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;
@end
