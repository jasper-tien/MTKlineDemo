//
//  MTDataManager.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTDataManager.h"
#import "SJKlineModel.h"
#import "MTCurveProcess.h"
@interface MTDataManager()
@property (nonatomic, strong) MTCurveProcess *curveProcess;
@end

@implementation MTDataManager
+ (instancetype)objectWithArray:(NSArray *)array {
    MTDataManager *dataManager = [[MTDataManager alloc] init];
    if (array.count >  0) {
        NSMutableArray *mainKLineDatas = [[NSMutableArray alloc] init];
        __block SJKlineModel *previousKlineModel = nil;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = (NSArray *)obj;
            if (arr.count == 6) {
                SJKlineModel *kLineModel = [[SJKlineModel alloc] init];
                [mainKLineDatas addObject:kLineModel];
                kLineModel.date = arr[0];
                kLineModel.open = @([arr[1] floatValue]);
                kLineModel.high = @([arr[2] floatValue]);
                kLineModel.low = @([arr[3] floatValue]);
                kLineModel.close = @([arr[4] floatValue]);
                kLineModel.volume = @([arr[5] floatValue]);
                kLineModel.mainKLineModels = mainKLineDatas;
                kLineModel.previousKlineModel = previousKlineModel;
                [kLineModel initData];
                
                previousKlineModel = kLineModel;
            }
        }];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:mainKLineDatas forKey:@"mainKLineDatas"];
        dataManager.curveProcess = [[MTCurveProcess alloc] init];
        NSDictionary *techDic = [dataManager.curveProcess curvTechDatasWithArray:mainKLineDatas];
        [dic addEntriesFromDictionary:techDic];
        dataManager.dataModelDictionary = dic;
    }
    
    return dataManager;
}

#pragma mark - public methods
- (NSArray *)getDataModelDictionary {
    return nil;
}

- (NSArray *)getMainKLineDatas {
    return self.dataModelDictionary[@"mainKLineDatas"];
}

- (NSArray *)getMainKLineDatasWithRange:(NSRange)range {
    NSArray *mainKlineDatas = self.dataModelDictionary[@"mainKLineDatas"];
    if (range.location >= mainKlineDatas.count) {
        return nil;
    }
    
    if ((range.location + range.length) > mainKlineDatas.count) {
        range.length = mainKlineDatas.count - range.location;
    }
    
    return [NSArray arrayWithArray:[mainKlineDatas subarrayWithRange:range]];
}

- (NSArray *)getVolumeDatas {
    return nil;
}

- (NSArray *)getCurveDatasWithType:(SJCurveTechType)curveTechType {
    return nil;
}

#pragma mark - private methods

@end
