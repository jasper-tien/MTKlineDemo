//
//  QSTrendViewModel.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendViewModel.h"
#import "QSPointKLineModel.h"
#import "QSKlineModel.h"
#import "QSPointShareTimeModel.h"
#import "QSTrendShareTimeVM.h"
#import "QSTrendKLineVM.h"
#import "QSCurveProcess.h"
#import "QSConstant.h"

@interface QSTrendViewModel()
@property (nonatomic, strong, readwrite) QSTrendShareTimeVM *shareTimeVM;
@property (nonatomic, strong, readwrite) QSTrendKLineVM *kLineVM;
@property (nonatomic, copy) NSDictionary *techsDataModelDic;//数据管理池(数据容器)
@property (nonatomic, strong) QSCurveProcess *curveProcess;

@end

@implementation QSTrendViewModel

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self makeCurveProcess];
        [self makeKLineVM];
    }
    return self;
}

#pragma mark - Public Metheds

- (void)loadShareTimeData {
    
}

- (void)loadKLineData {
    [self loadData];
}

- (void)loadKLastLineData {
    
}

- (void)loadNextKLineData {
    
}

- (void)drawKLineWithRange:(NSRange)range {
    NSArray *needShowDatas = [self getMainKLineDatasWithRange:range];
    if (!needShowDatas || needShowDatas.count == 0) {
        return;
    }
    
    [self.kLineVM drawView:needShowDatas];
}

#pragma mark - kLine data

- (void)updateData:(NSArray<QSPointKLineModel *> *)datas {
    self.techsDataModelDic = [self kLineModelsWithPointDatas:datas];
}

- (void)updateDataWithNextData:(NSArray<QSPointKLineModel *> *)datas {
    self.techsDataModelDic = [self kLineModelsWithPointDatas:datas];
}

- (void)updateDataWithLastData:(NSArray<QSPointKLineModel *> *)datas {
    self.techsDataModelDic = [self kLineModelsWithPointDatas:datas];
}

- (NSDictionary *)kLineModelsWithPointDatas:(NSArray<QSPointKLineModel *> *)array {
    NSMutableArray *mainKLineDatas = [[NSMutableArray alloc] init];
    __block QSKlineModel *previousKlineModel = nil;
    [array enumerateObjectsUsingBlock:^(QSPointKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSKlineModel *kLineModel = [[QSKlineModel alloc] init];
        [mainKLineDatas addObject:kLineModel];
        kLineModel.date = obj.time;
        kLineModel.open = obj.open;
        kLineModel.high = obj.high;
        kLineModel.low = obj.low;
        kLineModel.close = obj.close;
        kLineModel.volume = obj.volume;
        kLineModel.mainKLineModels = mainKLineDatas;
        kLineModel.previousKlineModel = previousKlineModel;
        [kLineModel initData];
        
        previousKlineModel = kLineModel;
    }];
    
    NSDictionary *techDic = [self.curveProcess curvTechDatasWithArray:mainKLineDatas];
    
    return techDic;
}

- (void)makeCurveProcess {
    if (!self.curveProcess) {
        self.curveProcess = [[QSCurveProcess alloc] init];
    }
}

#pragma mark - get

- (NSDictionary *)getDataModelDictionary {
    return self.techsDataModelDic.mutableCopy;
}

- (NSArray *)getMainKLineDatas {
    return [self getCurveDatasWithType:QSCurveTechType_KLine];
}

- (NSArray *)getMainKLineDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:QSCurveTechType_KLine range:range];
}

- (NSArray *)getKDJDatas {
    return [self getCurveDatasWithType:QSCurveTechType_KDJ];
}

- (NSArray *)getKDJDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:QSCurveTechType_KDJ range:range];
}

- (NSArray *)getBOLLDatas {
    return [self getCurveDatasWithType:QSCurveTechType_BOLL];
}

- (NSArray *)getBOLLDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:QSCurveTechType_BOLL range:range];
}

- (NSArray *)getMACDDatas {
    return [self getCurveDatasWithType:QSCurveTechType_MACD];
}
- (NSArray *)getMACDDatasWithRange:(NSRange)range {
    return [self getCurveDatasWithType:QSCurveTechType_MACD range:range];
}

- (NSArray *)getCurveDatasWithType:(QSCurveTechType)curveTechType {
    NSInteger techType = curveTechType;
    NSArray *techModels = @[];
    switch (techType) {
        case QSCurveTechType_KLine:{
            techModels = self.techsDataModelDic[@"mainKLineDatas"];
        }
            break;
        case QSCurveTechType_Volume:{
            techModels = self.techsDataModelDic[@"mainKLineDatas"];
        }
            break;
        case QSCurveTechType_Jine:{
//            techModels =
        }
            break;
        case QSCurveTechType_MACD:{
            techModels = self.techsDataModelDic[@"MTCurveMACDKey"];
        }
            break;
        case QSCurveTechType_KDJ:{
            techModels = self.techsDataModelDic[@"MTCurveKDJKey"];
        }
            break;
        case QSCurveTechType_BOLL:{
            techModels = self.techsDataModelDic[@"MTCurveBOLLKey"];
        }
            break;
            
        default:
            break;
    }
    return techModels;
}

- (NSArray *)getCurveDatasWithType:(QSCurveTechType)curveTechType range:(NSRange)range {
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


#pragma mark - Private Methods

- (void)loadData {
    NSArray *datas = [self createKLineDataSource:300];
    [self performSelector:@selector(successBackData:) withObject:datas afterDelay:0.25];
}

- (void)successBackData:(NSArray *)datas {
    [self updateData:datas];
    NSArray *needShowDatas = [self getMainKLineDatasWithRange:NSMakeRange(0, 100)];
    [self.kLineVM drawView:needShowDatas];
}

- (void)loadMoreData {
    
}

- (void)makeShareTimeVM {
    if (!self.shareTimeVM) {
        self.shareTimeVM = [[QSTrendShareTimeVM alloc] init];
    }
}

- (void)makeKLineVM {
    if (!self.kLineVM) {
        self.kLineVM = [[QSTrendKLineVM alloc] init];
    }
}

#pragma mark - Make Data

- (nonnull NSArray<QSPointShareTimeModel *> *)createShareTimeDataSource:(NSInteger)count {
    if (count <= 0) {
        return @[];
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        CGFloat price = 0;
        CGFloat volume = 0;
        if (i < 20) {
            price = (arc4random() % 10) + 60;
            volume = (arc4random() % 60) + 10;
        } else if (i > 20 && i < 60) {
            price = (arc4random() % 10) + 20;
            volume = arc4random() % 10 + 20;
        }else {
            price = (arc4random() % 10) +10;
            volume = (arc4random() % 10) +10;
        }
        NSString *date = @"10:30";
        QSPointShareTimeModel *model = [[QSPointShareTimeModel alloc] init];
        model.price = price;
        model.preClosePrice = 50;
        model.volume = volume;
        model.time = date;
        [models addObject:model];
    }
    
    return models;
}

- (nonnull NSArray<QSPointKLineModel *> *)createKLineDataSource:(NSInteger)count {
    if (count <= 0) {
        return @[];
    }
    
    NSMutableArray<QSPointKLineModel *> *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        int open = (arc4random() % 1000) + 1;
        int close = (arc4random() % 1000) + 1;
        CGFloat high = 0;
        CGFloat low = 0;
        if (ABS(close - open) > 300) {
            if (close > open) {
                close = open + arc4random() % 300;
                
                high = close + arc4random() % 50;
                
                int lo = open - arc4random() % 50;
                if (lo <= 0) {
                    lo = 0;
                }
                low = lo;
                
            }else {
                open = close + arc4random() % 300;
                
                high = open + arc4random() % 50;
                
                int lo = close - arc4random() % 50;
                if (lo <= 0) {
                    lo = 0;
                }
                low = lo;
            }
        }
        
        CGFloat volume = (arc4random() % 100) + 500;
        NSString *time = [NSString stringWithFormat:@"%d", (arc4random() % 1000) + 1];
        
        QSPointKLineModel *model = [[QSPointKLineModel alloc] init];
        model.open = open;
        model.high = high;
        model.low = low;
        model.close = close;
        model.volume = volume;
        model.time = time;
        [array addObject:model];
    }
    
    return array;
}

@end
