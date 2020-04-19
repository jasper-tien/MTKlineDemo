//
//  QSVolumePositionModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSVolumePositionModel : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGPoint volumePoint;
@property (nonatomic, assign) CGPoint startPoint;

@end

NS_ASSUME_NONNULL_END
