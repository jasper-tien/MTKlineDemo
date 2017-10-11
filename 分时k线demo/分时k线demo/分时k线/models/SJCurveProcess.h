//
//  SJCurveProcess.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/21.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJKlineModel.h"

//指标公式计算
@interface SJCurveProcess : NSObject
+ (NSDictionary *)CurveDatas:(NSArray<SJKlineModel *> *)baseDatas curveShowTypes:(NSArray *)types;

@end
