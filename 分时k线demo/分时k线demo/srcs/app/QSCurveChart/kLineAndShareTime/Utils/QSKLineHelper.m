//
//  QSKLineHelper.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/6.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSKLineHelper.h"

@implementation QSKLineHelper

+ (NSRange)rangeWithArrayCount:(NSInteger)count oldRange:(NSRange)oldRange direction:(QSRangeDirection)direction {
    NSInteger location = oldRange.location;
    NSInteger length = oldRange.length;
    if (direction == QSRangeDirectionLeft) {
        if (length > count) {
            return NSMakeRange(0, count);
        }
        NSInteger newLocation = location - length;
        if (newLocation > count) {
            newLocation = count - length;
        }
        if (newLocation < 0) {
            newLocation = 0;
        }
        return NSMakeRange(newLocation, length);
    } else if (direction == QSRangeDirectionRight) {
        if (length > count) {
            return NSMakeRange(0, count);
        }
        NSInteger newLocation = location;
        NSInteger lastObjIndex = location + length;
        if (lastObjIndex > count) {
            newLocation = count - length;
        }
        return NSMakeRange(newLocation, length);
    }
    return NSMakeRange(0, 0);
}

@end
