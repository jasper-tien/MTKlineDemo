//
//  QSMALine.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "QSConstant.h"

typedef NS_ENUM(NSInteger, MTMAType){
    MT_MA5Type = 0,
    MT_MA10Type,
    MT_MA20Type,
    MT_MA30Type,
    MT_BOLL_MB,
    MT_BOLL_UP,
    MT_BOLL_DN,
    MT_KDJ_K,
    MT_KDJ_D,
    MT_KDJ_J,
    MT_MACD_DIF,
    MT_MACD_DEA
};

NS_ASSUME_NONNULL_BEGIN

@interface QSMALine : NSObject

@property (nonatomic, strong) NSArray *MAPositions;
@property (nonatomic, assign) MTMAType MAType;
@property (nonatomic, assign) QSCurveTechType techType;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end

NS_ASSUME_NONNULL_END
