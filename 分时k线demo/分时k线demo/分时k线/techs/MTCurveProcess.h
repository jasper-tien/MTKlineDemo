//
//  MTCurveProcess.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SJKlineModel;
@interface MTCurveProcess : NSObject

- (NSDictionary *)curvTechDatasWithArray:(NSArray<SJKlineModel *> *)baseDatas;

@end
