//
//  MTCurveProcess.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTCurveProcess.h"
#import "MTCurveMACD.h"
#import <objc/runtime.h>

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

//创建指标实例
- (MTCurveObject *)createWithClassName:(NSString *)clsName {
    if (!clsName || ![clsName isKindOfClass:[NSString class]]) {
        return nil;
    }
    Class cls = NSClassFromString(clsName);
    return (MTCurveObject *)[[cls alloc] init];
}

//计算指标
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
    
    //计算指标
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
                    NSMutableArray *array = (NSMutableArray *)self.techDatasDic[@"MTCurveMACDKey"];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:array index:idx];
                    if (array) {
                        [array addObject:curveObject];
                    }
                    break;
                }
                case SJCurveTechType_KDJ: {
                    //  KDJ
                    NSMutableArray *array = (NSMutableArray *)self.techDatasDic[@"MTCurveKDJKey"];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:array index:idx];
                    if (array) {
                        [array addObject:curveObject];
                    }
                    break;
                }
                case SJCurveTechType_BOLL: {
                    //  布林线
                    NSMutableArray *array = (NSMutableArray *)self.techDatasDic[@"MTCurveBOLLKey"];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:array index:idx];
                    if (array) {
                        [array addObject:curveObject];
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

@end
