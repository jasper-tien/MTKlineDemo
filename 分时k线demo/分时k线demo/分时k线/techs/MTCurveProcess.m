//
//  MTCurveProcess.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTCurveProcess.h"
#import "MTCurveObject.h"
#import <objc/runtime.h>
#import "SJCurveChartConstant.h"

#define RegisterClassName @"registerClassName"
#define RegisterClassKey @"registerClassKey"

@interface MTCurveProcess()
@property (nonatomic, copy) NSArray *curveSubclassArray;
@property (nonatomic, copy) NSDictionary *techDatasDic;
@end

@implementation MTCurveProcess
- (instancetype)init {
    if (self = [super init]) {
        [self registerCurveSubclass];
    }
    
    return self;
}

//注册指标类名
- (void)registerCurveSubclass {
    NSMutableArray *curveSubclassArray = [NSMutableArray array];
    //注册MACD指标类名
    NSDictionary *MACDDic = [NSDictionary dictionaryWithObjectsAndKeys:@"MTCurveMACD", RegisterClassName, @"MTCurveMACDKey", RegisterClassKey, nil];
    //注册KDJ指标类名
    NSDictionary *KDJDic = [NSDictionary dictionaryWithObjectsAndKeys:@"MTCurveKDJ", RegisterClassName, @"MTCurveKDJKey", RegisterClassKey, nil];
    //注册BOLL指标类名
    NSDictionary *BOLLDic = [NSDictionary dictionaryWithObjectsAndKeys:@"MTCurveBOLL", RegisterClassName, @"MTCurveBOLLKey", RegisterClassKey, nil];
    
    [curveSubclassArray addObject:MACDDic];
    [curveSubclassArray addObject:KDJDic];
    [curveSubclassArray addObject:BOLLDic];
    self.curveSubclassArray = curveSubclassArray;
}

//===================================================================================================================
// 计算指标
// 在此地方遍历原始数据，计算需要计算的指标。
// 计算指标的具体做法：
//  为了减少计算指标时相互间的影响，采取分布式计算方式，即：把计算指标的逻辑下方到具体的某个指标类中，具体的指标计算逻辑由各自来完成，本类是完全不知道各自指标的计算业务。这样做的目的还可以清晰代码，方便bug的查找和更迭。
// 新增指标步骤：
// 1、新增指标类必须继承 MTCurveObject 并实现相应的方法。
// 2、在- (void)registerCurveSubclass{}方法中，按照现在的注册规则，注册新增的指标。
// 3、在- (NSDictionary *)curvTechDatasWithArray:(NSArray<SJKlineModel *> *)baseDatas 实现新增指标的计算代码。
//===================================================================================================================
- (NSDictionary *)curvTechDatasWithArray:(NSArray<SJKlineModel *> *)baseDatas {
    if (baseDatas.count <= 0) {
        return nil;
    }
    
    if (self.curveSubclassArray.count <= 0) {
        NSLog(@"需要计算的指标为0个！");
        return nil;
    }
    
    //初始化存放结果的容器
    NSInteger techCount = baseDatas.count;
    NSMutableDictionary *techsDataModelDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *registerClsDic in self.curveSubclassArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:techCount];
        NSString *techKey = registerClsDic[RegisterClassKey];
        [techsDataModelDic setValue:array forKey:techKey];
    }
    [techsDataModelDic setObject:baseDatas forKey:@"mainKLineDatas"];
    self.techDatasDic = techsDataModelDic;
    
    __weak MTCurveProcess *weakSelf = self;
    [baseDatas enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSDictionary *registerClsDic in weakSelf.curveSubclassArray) {
            MTCurveObject *curveObject = [weakSelf createWithClassName:registerClsDic[RegisterClassName]];
            if (![curveObject isKindOfClass:[MTCurveObject class]]) {
                break;
            }
            
            switch (curveObject.curveTechType) {
                case SJCurveTechType_KLine:
                    break;
                case SJCurveTechType_Volume:
                    // 成交量
                    break;
                case SJCurveTechType_Jine:
                    //  成交额
                    break;
                case SJCurveTechType_MACD: {
                    //  MACD
                    NSMutableArray *MACDDatas = (NSMutableArray *)self.techDatasDic[@"MTCurveMACDKey"];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:MACDDatas index:idx];
                    if (MACDDatas) {
                        [MACDDatas addObject:curveObject];
                    }
                    break;
                }
                case SJCurveTechType_KDJ: {
                    //  KDJ
                    NSMutableArray *KDJDatas = (NSMutableArray *)self.techDatasDic[@"MTCurveKDJKey"];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:KDJDatas index:idx];
                    if (KDJDatas) {
                        [KDJDatas addObject:curveObject];
                    }
                    break;
                }
                case SJCurveTechType_BOLL: {
                    //  布林线
                    NSMutableArray *BOLLDatas = (NSMutableArray *)self.techDatasDic[@"MTCurveBOLLKey"];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:BOLLDatas index:idx];
                    if (BOLLDatas) {
                        [BOLLDatas addObject:curveObject];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }];
    
    return techsDataModelDic;
}

//创建指标实例
- (MTCurveObject *)createWithClassName:(NSString *)clsName {
    if (!clsName || ![clsName isKindOfClass:[NSString class]]) {
        return nil;
    }
    Class cls = NSClassFromString(clsName);
    return (MTCurveObject *)[[cls alloc] init];
}

@end
