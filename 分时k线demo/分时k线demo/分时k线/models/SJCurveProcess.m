
//
//  SJCurveProcess.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/21.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "SJCurveProcess.h"
#import "SJCurveObject.h"

@implementation SJCurveProcess

+ (NSDictionary *)CurveDatas:(NSArray<SJKlineModel *> *)baseDatas curveShowTypes:(NSArray *)types{
    if (baseDatas.count <= 0 || types.count <= 0) {
        return nil;
    }
    
    NSMutableDictionary *curveDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < types.count; i++) {
        NSInteger type = [types[i] integerValue];
        if (SJCurveTechType_KLine == type) {
            SJCurveObject *curveType = [SJCurveProcess initCurveWithTechType:SJCurveTechType_KLine count:baseDatas.count];
            if (curveType) {
                [curveDic setValue:curveType forKey:@"CurveTechKLine"];
            }
        } else if (SJCurveTechType_Volume == type) {
            SJCurveObject *curveType = [SJCurveProcess initCurveWithTechType:SJCurveTechType_Volume count:baseDatas.count];
            if (curveType) {
                [curveDic setValue:curveType forKey:@"CurveTechVolume"];
            }
        } else if (SJCurveTechType_Jine == type) {
            SJCurveObject *curveType = [SJCurveProcess initCurveWithTechType:SJCurveTechType_Jine count:baseDatas.count];
            if (curveType) {
                [curveDic setValue:curveType forKey:@"CurveTechJine"];
            }
        } else if (SJCurveTechType_MACD == type) {
            SJCurveObject *curveType = [SJCurveProcess initCurveWithTechType:SJCurveTechType_MACD count:baseDatas.count];
            if (curveType) {
                [curveDic setValue:curveType forKey:@"CurveTechMACD"];
            }
        } else if (SJCurveTechType_KDJ == type) {
            SJCurveObject *curveType = [SJCurveProcess initCurveWithTechType:SJCurveTechType_KDJ count:baseDatas.count];
            if (curveType) {
                [curveDic setValue:curveType forKey:@"CurveTechKDJ"];
            }
        } else if (SJCurveTechType_BOLL == type) {
            SJCurveObject *curveType = [SJCurveProcess initCurveWithTechType:SJCurveTechType_BOLL count:baseDatas.count];
            if (curveType) {
                [curveDic setValue:curveType forKey:@"CurveTechBOLL"];
            }
        }
    }
    
    [self initValuesWithBaseModels:baseDatas curveObjectDictionary:curveDic];
    
    return curveDic;
}


+ (void)TechValueWithDatas:(NSArray<SJKlineModel *> *)baseDatas curveObject:(SJCurveObject *)curveObject {
    SJCurveTechType techType = curveObject.curveTechType;
    switch (techType) {
        case SJCurveTechType_KLine:
            
            break;
        case SJCurveTechType_Volume: {
            
        }
            
            break;
        case SJCurveTechType_Jine: {
            
        }
            
            break;
        case SJCurveTechType_MACD: {
        
        }
            
            break;
        case SJCurveTechType_KDJ: {
            
        }
            
            break;
        case SJCurveTechType_BOLL: {
            
        }
            
            break;
            
        default:
            break;
    }
}

+ (void)initValuesWithBaseModels:(NSArray<SJKlineModel *> *)baseDatas curveObjectDictionary:(NSDictionary *)curveObjectDic {
    [baseDatas enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

+ (SJCurveObject *)initCurveWithTechType:(SJCurveTechType)curveTechType count:(NSInteger)count {
    SJCurveObject *curveObject = [[SJCurveObject alloc] init];
    switch (curveTechType) {
        case SJCurveTechType_KLine: {
            curveObject.curveTechType = SJCurveTechType_KLine;
            curveObject.curveDataArrayCount = 4;
        }
            break;
        case SJCurveTechType_Volume: {
            curveObject.curveTechType = SJCurveTechType_Volume;
            curveObject.curveDataArrayCount = 4;
        }
            
            break;
        case SJCurveTechType_Jine: {
            curveObject.curveTechType = SJCurveTechType_Jine;
            curveObject.curveDataArrayCount = 4;
        }
            
            break;
        case SJCurveTechType_MACD: {
            int curveCount = 3;
            curveObject.curveTechType = SJCurveTechType_MACD;
            curveObject.curveDataArrayCount = curveCount;
            
            //DIFF
            SJCurveData *curveData_DIFF = [[SJCurveData alloc] init];
            curveData_DIFF.curveShowType = SJCurveShowType_PointLine;
            curveData_DIFF.color = Curve_Color_White;
            curveData_DIFF.period = 1;
            curveData_DIFF.valueArray = [NSMutableArray arrayWithCapacity:count];
            
            //DEA
            SJCurveData *curveData_DEA = [[SJCurveData alloc] init];
            curveData_DEA.curveShowType = SJCurveShowType_PointLine;
            curveData_DEA.color = Curve_Color_Yellow;
            curveData_DEA.period = 1;
            curveData_DEA.valueArray = [NSMutableArray arrayWithCapacity:count];
            
            //MACD
            SJCurveData *curveData_MACD = [[SJCurveData alloc] init];
            curveData_MACD.curveShowType = SJCurveShowType_RedGreenUpOrDown;
            curveData_MACD.color = Curve_Color_None;
            curveData_MACD.period = 1;
            curveData_MACD.valueArray = [NSMutableArray arrayWithCapacity:count];
        }
            
            break;
        case SJCurveTechType_KDJ: {
            curveObject.curveTechType = SJCurveTechType_KDJ;
            curveObject.curveDataArrayCount = 4;
            
            //RSV
            SJCurveData *curveData_RSV = [[SJCurveData alloc] init];
            curveData_RSV.curveShowType = SJCurveShowType_PointLine;
            curveData_RSV.color = Curve_Color_None;
            curveData_RSV.period = 9;
            curveData_RSV.valueArray = [NSMutableArray arrayWithCapacity:count];
            
            //K
            SJCurveData *curveData_K = [[SJCurveData alloc] init];
            curveData_K.curveShowType = SJCurveShowType_PointLine;
            curveData_K.color = Curve_Color_White;
            curveData_K.period = 3;
            curveData_K.valueArray = [NSMutableArray arrayWithCapacity:count];
            
            //D
            SJCurveData *curveData_D = [[SJCurveData alloc] init];
            curveData_D.curveShowType = SJCurveShowType_PointLine;
            curveData_D.color = Curve_Color_Yellow;
            curveData_D.period = 3;
            curveData_D.valueArray = [NSMutableArray arrayWithCapacity:count];
            
            //J
            SJCurveData *curveData_J = [[SJCurveData alloc] init];
            curveData_J.curveShowType = SJCurveShowType_PointLine;
            curveData_J.color = Curve_Color_Purple;
            curveData_J.period = 1;
            curveData_J.valueArray = [NSMutableArray arrayWithCapacity:count];
        }
            
            break;
        case SJCurveTechType_BOLL: {
            curveObject.curveTechType = SJCurveTechType_BOLL;
            curveObject.curveDataArrayCount = 3;
        }
            
            break;
            
        default:
            break;
    }
    
    return curveObject;
}

@end
