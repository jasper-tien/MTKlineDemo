//
//  SJCurveObject.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/21.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJCurveChartConstant.h"

//曲线数据，每条曲线作为基本数据单元
@interface SJCurveData : NSObject
@property (nonatomic) SJCurveShowType curveShowType;
@property (nonatomic, copy) NSArray *valueArray;//一条曲线的数据
@property (nonatomic) NSInteger color;          //曲线的颜色
@property (nonatomic) NSInteger period;         //周期

@end

@interface SJCurveObject : NSObject
@property (nonatomic) SJCurveTechType curveTechType;
@property (nonatomic, copy) NSArray<SJCurveData *> *curveDataArray; //曲线数组
@property (nonatomic) NSInteger curveDataArrayCount;                //曲线的数量
@end
