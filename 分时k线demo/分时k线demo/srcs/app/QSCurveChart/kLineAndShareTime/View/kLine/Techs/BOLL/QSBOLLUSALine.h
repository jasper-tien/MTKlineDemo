//
//  QSBOLLUSALine.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QSPointPositionKLineModel;
@interface QSBOLLUSALine : NSObject

@property (nonatomic, strong) QSPointPositionKLineModel *positionModel;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end

NS_ASSUME_NONNULL_END
