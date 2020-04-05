//
//  QSTrendKLineVM.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendKLineVM.h"
#import "QSPointKLineModel.h"
#import "QSPointPositionKLineModel.h"
#import "QSKlineModel.h"
#import "QSConstant.h"
#import "QSCurveChartGlobalVariable.h"
#import <UIKit/UIGeometry.h>

@interface QSTrendKLineVM ()

@property (nonatomic, strong, readwrite) NSMutableArray<QSPointPositionKLineModel *> *needDrawPositionModels;
@property (nonatomic, copy) NSArray<QSKlineModel *> *needDrawKlneModels;
@property (nonatomic, strong, readwrite) NSMutableArray *MA5Positions; /// MA5位置数组
@property (nonatomic, strong, readwrite) NSMutableArray *MA10Positions; /// MA10位置数组
@property (nonatomic, strong, readwrite) NSMutableArray *MA20Positions; /// MA20位置数组
@property (nonatomic, assign, readwrite) CGFloat currentPriceMax; /// 当前价格最大值
@property (nonatomic, assign, readwrite) CGFloat currentPriceMin; /// 当前价格最小值
@property (nonatomic, assign, readwrite) CGFloat currentPriceMaxToViewY; /// 当前价格最大值对应到视图上的纵坐标
@property (nonatomic, assign, readwrite) CGFloat currentPriceMinToViewY; /// 当前价格最小值对应到视图上的纵坐标
@property (nonatomic, assign, readwrite) CGFloat unitViewY; ///视图上单位坐标表示的价格值
@property (nonatomic, strong, readwrite) QSKlineModel *showKlineModel;

@end

@implementation QSTrendKLineVM

- (instancetype)init {
    if (self = [super init]) {
        self.needDrawPositionModels = @[].mutableCopy;
        self.MA5Positions = @[].mutableCopy;
        self.MA10Positions = @[].mutableCopy;
        self.MA20Positions = @[].mutableCopy;
        self.currentPriceMax = 0;
        self.currentPriceMin = 0;
        self.currentPriceMinToViewY = 0;
        self.currentPriceMaxToViewY = 200;
        self.unitViewY = 0.0f;
    }
    return self;
}

#pragma mark - Public methods

- (void)drawView:(NSArray<QSKlineModel *>*)needDrawKlneModels {
    if (self.delegate && [self.delegate respondsToSelector:@selector(kLineVM:willUpdateView:)]) {
        [self.delegate kLineVM:self willUpdateView:YES];
    }
    
    self.needDrawKlneModels = needDrawKlneModels;
    [self convertToKLinePositionModelWithKLineModels];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kLineVM:didUpdateView:)]) {
        [self.delegate kLineVM:self didUpdateView:YES];
    }
}

#pragma mark -
//把需要绘制的KLineModel转换成对应屏幕坐标model
- (void)convertToKLinePositionModelWithKLineModels {
    if (self.needDrawKlneModels.count <= 0) {
        return;
    }
    
    if (![self lookupKlineDataMaxAndMin]) {
        return;
    }
    
    self.currentPriceMin *= 0.9991;
    self.currentPriceMax *= 1.0001;
    
    self.currentPriceMinToViewY = QSCurveChartKLineMainViewMinY;
    self.currentPriceMaxToViewY = 200 - QSCurveChartKLineMainViewMinY;
    
    //计算view上单位距离对应的数据值
    self.unitViewY = (self.currentPriceMax - self.currentPriceMin) / (self.currentPriceMaxToViewY - self.currentPriceMinToViewY);
    
    //移除旧的值
    [self.MA5Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA20Positions removeAllObjects];
    
    //计算需要实现的数据对应到屏幕上的坐标
    [self.needDrawKlneModels enumerateObjectsUsingBlock:^(QSKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSKlineModel *kLineModel = obj;
        if ([kLineModel isKindOfClass:[QSKlineModel class]]) {
            CGFloat ponitScreenX = idx * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
            
            CGPoint openPoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.open - self.currentPriceMin) / self.unitViewY));
            CGPoint closePoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.close - self.currentPriceMin) / self.unitViewY));
            CGPoint highPoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.high - self.currentPriceMin) / self.unitViewY));
            CGPoint lowPoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.low - self.currentPriceMin) / self.unitViewY));
            
            QSPointPositionKLineModel *positionModel = [[QSPointPositionKLineModel alloc] init];
            positionModel.openPoint = openPoint;
            positionModel.closePoint = closePoint;
            positionModel.highPoint = highPoint;
            positionModel.lowPoint = lowPoint;
            [self.needDrawPositionModels addObject:positionModel];
            
            //MA坐标转换
            CGFloat ma5ScreenY = self.currentPriceMaxToViewY;
            CGFloat ma10ScreenY = self.currentPriceMaxToViewY;
            CGFloat ma20ScreenY = self.currentPriceMaxToViewY;
            if(kLineModel.MA_5)
            {
                ma5ScreenY = self.currentPriceMaxToViewY - (kLineModel.MA_5 - self.currentPriceMin) / self.unitViewY;
            }
            if(kLineModel.MA_20)
            {
                ma20ScreenY = self.currentPriceMaxToViewY - (kLineModel.MA_20 - self.currentPriceMin) / self.unitViewY;
            }
            if (kLineModel.MA_10) {
                ma10ScreenY = self.currentPriceMaxToViewY - (kLineModel.MA_10 - self.currentPriceMin) / self.unitViewY;
            }
            CGPoint ma5ScreenPoint = CGPointMake(ponitScreenX, ma5ScreenY);
            CGPoint ma10ScreenPoint = CGPointMake(ponitScreenX, ma10ScreenY);
            CGPoint ma20ScreenPoint = CGPointMake(ponitScreenX, ma20ScreenY);
            
            [self.MA5Positions addObject:[NSValue valueWithCGPoint:ma5ScreenPoint]];
            [self.MA10Positions addObject:[NSValue valueWithCGPoint:ma10ScreenPoint]];
            [self.MA20Positions addObject:[NSValue valueWithCGPoint:ma20ScreenPoint]];
        }
    }];
}

- (BOOL)lookupKlineDataMaxAndMin {
    if (self.needDrawKlneModels.count <= 0) {
        return NO;
    }
    //确定最大值和最小值
    QSKlineModel *firstModel = self.needDrawKlneModels.firstObject;
    __block CGFloat assertMax = firstModel.high;
    __block CGFloat assertMin = firstModel.low;
    [self.needDrawKlneModels enumerateObjectsUsingBlock:^(QSKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.high > assertMax) {
            assertMax = obj.high;
        }
        if (obj.low < assertMin) {
            assertMin = obj.low;
        }
        
        if(obj.MA_5)
        {
            if (obj.MA_5 > assertMax) {
                assertMax = obj.MA_5;
            }
            if (obj.MA_5 < assertMin) {
                assertMin = obj.MA_5;
            }
        }
        if(obj.MA_10)
        {
            if (obj.MA_10 > assertMax) {
                assertMax = obj.MA_10;
            }
            if (obj.MA_5 < assertMin) {
                assertMin = obj.MA_10;
            }
        }
        if(obj.MA_20)
        {
            if (obj.MA_20 > assertMax) {
                assertMax = obj.MA_20;
            }
            if (obj.MA_30 < assertMin) {
                assertMin = obj.MA_20;
            }
        }
    }];
    
    self.currentPriceMin = assertMin;
    self.currentPriceMax = assertMax;
    
    return YES;
}

- (void)reDrawShowViewWithIndex:(NSInteger)index {
    if (index == -1) {
        self.showKlineModel = self.needDrawKlneModels.lastObject;
        if (self.delegate && [self.delegate respondsToSelector:@selector(kLineVM:drawTopDetailsView:)]) {
            [self.delegate kLineVM:self drawTopDetailsView:self.showKlineModel];
        }
    } else if (index < self.needDrawKlneModels.count && index > 0) {
        self.showKlineModel = self.needDrawKlneModels[index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(kLineVM:drawTopDetailsView:)]) {
            [self.delegate kLineVM:self drawTopDetailsView:self.showKlineModel];
        }
    }
}

@end
