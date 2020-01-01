//
//  QSTrendKLineVM.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendKLineVM.h"
#import "QSPointKLineModel.h"
#import "QSKlineModel.h"
#import "QSCurveProcess.h"

@interface QSTrendKLineVM ()
@property (nonatomic, strong) QSCurveProcess *curveProcess;
@property (nonatomic, copy) NSDictionary *techsDataModelDic;//数据管理池(数据容器)
@property (nonatomic, strong, readwrite) NSMutableArray<QSPointPositionKLineModel *> *needDrawPositionModels;
@property (nonatomic, strong, readwrite) NSMutableArray *MA5Positions; /// MA5位置数组
@property (nonatomic, strong, readwrite) NSMutableArray *MA10Positions; /// MA10位置数组
@property (nonatomic, strong, readwrite) NSMutableArray *MA20Positions; /// MA20位置数组
@property (nonatomic, assign, readwrite) CGFloat currentPriceMax; /// 当前价格最大值
@property (nonatomic, assign, readwrite) CGFloat currentPriceMin; /// 当前价格最小值
@property (nonatomic, assign, readwrite) CGFloat currentPriceMaxToViewY; /// 当前价格最大值对应到视图上的纵坐标
@property (nonatomic, assign, readwrite) CGFloat currentPriceMinToViewY; /// 当前价格最小值对应到视图上的纵坐标
@property (nonatomic, assign, readwrite) CGFloat unitViewY; ///视图上单位坐标表示的价格值
@end

@implementation QSTrendKLineVM

- (instancetype)init {
    if (self = [super init]) {
        [self makeCurveProcess];
    }
    return self;
}

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

@end
