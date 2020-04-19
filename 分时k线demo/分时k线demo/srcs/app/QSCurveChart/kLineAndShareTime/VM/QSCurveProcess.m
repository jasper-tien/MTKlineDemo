//
//  QSCurveProcess.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSCurveProcess.h"
#import "QSCurveModel.h"
#import <objc/runtime.h>

#define RegisterClassName @"registerClassName"
#define RegisterClassKey @"registerClassKey"

NSString const* kMainKLineKey = @"QSMainKLineKey";
NSString const* kCurveKDJKey = @"QSCurveKDJKey";
NSString const* kCurveMACDKey = @"QSCurveMACDKey";
NSString const* kCurveBOLLKey = @"QSCurveBOLLKey";

@interface QSCurveProcess()
@property (nonatomic, copy) NSArray *curveSubclassArray;
@property (nonatomic, copy) NSDictionary *techDatasDic;
@end

@implementation QSCurveProcess

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
    NSDictionary *MACDDic = [NSDictionary dictionaryWithObjectsAndKeys:@"QSCurveMACD", RegisterClassName, kCurveMACDKey, RegisterClassKey, nil];
    //注册KDJ指标类名
    NSDictionary *KDJDic = [NSDictionary dictionaryWithObjectsAndKeys:@"QSCurveKDJ", RegisterClassName, kCurveKDJKey, RegisterClassKey, nil];
    //注册BOLL指标类名
    NSDictionary *BOLLDic = [NSDictionary dictionaryWithObjectsAndKeys:@"QSCurveBOLL", RegisterClassName, kCurveBOLLKey, RegisterClassKey, nil];
    
    [curveSubclassArray addObject:MACDDic];
    [curveSubclassArray addObject:KDJDic];
    [curveSubclassArray addObject:BOLLDic];
    self.curveSubclassArray = curveSubclassArray;
}

//创建指标实例
- (QSCurveModel *)createWithClassName:(NSString *)clsName {
    if (!clsName || ![clsName isKindOfClass:[NSString class]]) {
        return nil;
    }
    Class cls = NSClassFromString(clsName);
    return (QSCurveModel *)[[cls alloc] init];
}

//计算指标
- (NSDictionary *)curvTechDatasWithArray:(NSArray<QSKlineModel *> *)baseDatas {
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
    [techsDataModelDic setObject:baseDatas forKey:kMainKLineKey];
    self.techDatasDic = techsDataModelDic;
    
    //计算指标
    __weak QSCurveProcess *weakSelf = self;
    [baseDatas enumerateObjectsUsingBlock:^(QSKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSDictionary *registerClsDic in weakSelf.curveSubclassArray) {
            QSCurveModel *curveObject = [weakSelf createWithClassName:registerClsDic[RegisterClassName]];
            if (![curveObject isKindOfClass:[QSCurveModel class]]) {
                break;
            }
            
            switch (curveObject.curveTechType) {
                case QSCurveTechType_KLine:
                    break;
                case QSCurveTechType_Volume:
                    // 成交量
                    break;
                case QSCurveTechType_Jine:
                    //  成交额
                    break;
                case QSCurveTechType_MACD: {
                    //  MACD
                    NSMutableArray *array = (NSMutableArray *)self.techDatasDic[kCurveMACDKey];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:array index:idx];
                    if (array) {
                        [array addObject:curveObject];
                    }
                    break;
                }
                case QSCurveTechType_KDJ: {
                    //  KDJ
                    NSMutableArray *array = (NSMutableArray *)self.techDatasDic[kCurveKDJKey];
                    //计算指标
                    [curveObject reckonTechWithArray:baseDatas container:array index:idx];
                    if (array) {
                        [array addObject:curveObject];
                    }
                    break;
                }
                case QSCurveTechType_BOLL: {
                    //  布林线
                    NSMutableArray *array = (NSMutableArray *)self.techDatasDic[kCurveBOLLKey];
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
