//
//  QSCurveProcess.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString const* kMainKLineKey;
extern NSString const* kCurveKDJKey;
extern NSString const* kCurveMACDKey;
extern NSString const* kCurveBOLLKey;

@class QSKlineModel;
@interface QSCurveProcess : NSObject
//计算指标
- (NSDictionary *)curvTechDatasWithArray:(NSArray<QSKlineModel *> *)baseDatas;

@end

NS_ASSUME_NONNULL_END
