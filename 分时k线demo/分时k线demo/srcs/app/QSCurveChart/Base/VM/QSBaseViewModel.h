//
//  QSBaseViewModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "QSTrendViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSBaseViewModel : NSObject

@property (nonatomic, weak) id<QSTrendViewModelProtocol> parentViewModel;

@end

NS_ASSUME_NONNULL_END
