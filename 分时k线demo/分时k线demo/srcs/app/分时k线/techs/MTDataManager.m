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
#import "SJCurveChartConstant.h"

@interface MTDataManager()
@property (nonatomic, strong) MTCurveProcess *curveProcess;
@end

@implementation MTDataManager
- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        self.techsDataModelDic = [self kLineModelsWithSourceDatas:array];
    }
    
    return self;
}

#pragma mark - public methods
//刷新数据，把原始数据转化成数据model类型，并添加到数据管理池
- (void)inpouringSourceData:(NSArray *)array {
    if (array.count <= 0) {
        return;
    }
    
    NSDictionary *techDic =[self kLineModelsWithSourceDatas:array];
    if ([self techsDataModelDicAppendNewtechsData:techDic]) {
        NSLog(@"新增数据成功添加到数据管理池");
    }else {
        NSLog(@"新增数据添加到数据管理池失败");
    }
}

- (NSDictionary *)getDataModelDictionary {
    return self.techsDataModelDic.mutableCopy;
}

- (NSArray *)getMainKLineDatas {
    return [self getCurveDatasWithType:SJCurveTechType_KLine];
}

- (NSArray *)getMainKLineDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:SJCurveTechType_KLine range:range];
}

- (NSArray *)getKDJDatas {
    return [self getCurveDatasWithType:SJCurveTechType_KDJ];
}

- (NSArray *)getKDJDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:SJCurveTechType_KDJ range:range];
}

- (NSArray *)getBOLLDatas {
    return [self getCurveDatasWithType:SJCurveTechType_BOLL];
}

- (NSArray *)getBOLLDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:SJCurveTechType_BOLL range:range];
}

- (NSArray *)getMACDDatas {
    return [self getCurveDatasWithType:SJCurveTechType_MACD];
}
- (NSArray *)getMACDDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:SJCurveTechType_MACD range:range];
}

- (NSArray *)getCurveDatasWithType:(SJCurveTechType)curveTechType {
    NSInteger techType = curveTechType;
    NSArray *techModels = @[];
    switch (techType) {
        case SJCurveTechType_KLine:{
            techModels = self.techsDataModelDic[@"mainKLineDatas"];
        }
            break;
        case SJCurveTechType_Volume:{
            techModels = self.techsDataModelDic[@"mainKLineDatas"];
        }
            break;
        case SJCurveTechType_Jine:{
//            techModels =
        }
            break;
        case SJCurveTechType_MACD:{
            techModels = self.techsDataModelDic[@"MTCurveMACDKey"];
        }
            break;
        case SJCurveTechType_KDJ:{
            techModels = self.techsDataModelDic[@"MTCurveKDJKey"];
        }
            break;
        case SJCurveTechType_BOLL:{
            techModels = self.techsDataModelDic[@"MTCurveBOLLKey"];
        }
            break;
            
        default:
            break;
    }
    return techModels;
}

- (NSArray *)getCurveDatasWithType:(SJCurveTechType)curveTechType range:(NSRange)range {
    NSArray *rangeTechModels = @[];
    NSArray *techModels = [self getCurveDatasWithType:curveTechType];
    if (range.location >= techModels.count) {
        return rangeTechModels;
    }
    if ((range.location + range.length) > techModels.count) {
        range.length = techModels.count - range.location;
    }
    techModels = [NSArray arrayWithArray:[techModels subarrayWithRange:range]];
    return techModels;
}

#pragma mark - private methods
//原始数据转化成SJKlineModels
- (NSDictionary *)kLineModelsWithSourceDatas:(NSArray *)array {
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
    
    NSDictionary *techDic = [self.curveProcess curvTechDatasWithArray:mainKLineDatas];
    
    return techDic;
}

//增加新的数据model
- (BOOL)techsDataModelDicAppendNewtechsData:(NSDictionary *)newTechsDataModelDic {
    if (newTechsDataModelDic.allKeys <= 0) {
        return NO;
    }
    //
    return YES;
}

#pragma mark -
- (MTCurveProcess *)curveProcess {
    if (!_curveProcess) {
        _curveProcess = [[MTCurveProcess alloc] init];
    }
    
    return _curveProcess;
}
@end
