//
//  QSKLineHelper.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/6.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSKLineHelper : NSObject

+ (NSRange)rangeWithArrayCount:(NSInteger)count oldRange:(NSRange)oldRange direction:(QSRangeDirection)direction;

@end

NS_ASSUME_NONNULL_END
