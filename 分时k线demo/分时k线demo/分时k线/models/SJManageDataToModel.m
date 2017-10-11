//
//  SJManageDataToModel.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/19.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "SJManageDataToModel.h"
#import "SJKlineModel.h"

@interface SJManageDataToModel ()

@end

@implementation SJManageDataToModel
+ (instancetype)objectWithArray:(NSArray *)array {
    SJManageDataToModel *manageDataToModel = [[SJManageDataToModel alloc] init];
    if (array.count >  0) {
        manageDataToModel.dataModelDictionary = [[NSMutableDictionary alloc] init];
        NSMutableArray *mainKLineDatas = [[NSMutableArray alloc] init];
        SJKlineModel *previousKlineModel = nil;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = (NSArray *)obj;
            if (arr.count == 5) {
                SJKlineModel *kLineModel = [[SJKlineModel alloc] init];
                kLineModel.date = arr[0];
                kLineModel.open = @([arr[1] floatValue]);
                kLineModel.high = @([arr[2] floatValue]);
                kLineModel.low = @([arr[3] floatValue]);
                kLineModel.close = @([arr[4] floatValue]);
                kLineModel.mainKLineModels = mainKLineDatas;
                kLineModel.previousKlineModel = previousKlineModel;
                [mainKLineDatas addObject:kLineModel];
            }
        }];
        [manageDataToModel.dataModelDictionary setObject:mainKLineDatas forKey:@"mainKLineDatas"];
    }
    return manageDataToModel;
}

- (NSDictionary *)getDataModelDictionary {
    return nil;
}

- (SJCurveManager *)getMainKLineDatas {
    return nil;
}

- (SJCurveManager *)getVolumeDatas {
    return nil;
}

- (SJCurveManager *)getCurveDatasWithType:(SJCurveTechType)curveTechType {
    return nil;
}

@end
