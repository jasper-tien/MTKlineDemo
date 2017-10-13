//
//  MTMianKLineView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/9/30.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTMianKLineView.h"
#import "MTKLine.h"
#import "MTMALine.h"
#import "SJKlineModel.h"
#import "MTKLinePositionModel.h"
#import "SJCurveChartConstant.h"
#import "MTCurveChartGlobalVariable.h"
#import "UIColor+CurveChart.h"

@interface MTMianKLineView ()
//
@property (nonatomic, strong) NSMutableArray<MTKLinePositionModel *> *needDrawPositionModels;
/**
 *  MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA7Positions;


/**
 *  MA30位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA30Positions;

@end

@implementation MTMianKLineView
- (instancetype)initWithDelegate:(id<MTMianKLineViewDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.needDrawPositionModels = @[].mutableCopy;
        self.MA7Positions = @[].mutableCopy;
        self.MA30Positions = @[].mutableCopy;
        self.backgroundColor = [UIColor backgroundColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.needDrawPositionModels.count <= 0) {
        return;
    }
    NSString *titleStr = [NSString stringWithFormat:@"MA5 --  MA10 --  MA20 --"];
    CGPoint drawTitlePoint = CGPointMake(5, 0);
    [titleStr drawAtPoint:drawTitlePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : [UIColor mainTextColor]}];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    MTKLine *kLine = [[MTKLine alloc] initWithContext:context];
    [self.needDrawPositionModels enumerateObjectsUsingBlock:^(MTKLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTKLinePositionModel *positionModel = obj;
        kLine.positionModel = positionModel;
        [kLine draw];
    }];
    
    MTMALine *MALine = [[MTMALine alloc] initWithContext:context];
    MALine.techType = SJCurveTechType_KLine;
    MALine.MAType = MT_MA7Type;
    MALine.MAPositions = self.MA7Positions;
    [MALine draw];
    
    MALine.MAType = MT_MA30Type;
    MALine.MAPositions = self.MA30Positions;
    [MALine draw];
}

#pragma mark -
- (void)drawMainView {
    [self convertToKLinePositionModelWithKLineModels];
}

#pragma mark -
//把需要绘制的KLineModel转换成对应屏幕坐标model
- (void)convertToKLinePositionModelWithKLineModels {
    if (!self.needDrawKlneModels) {
        return;
    }
    
    //确定最大值和最小值
    SJKlineModel *firstModel = self.needDrawKlneModels.firstObject;
    __block CGFloat assertMax = firstModel.high.floatValue;
    __block CGFloat assertMin = firstModel.low.floatValue;
    [self.needDrawKlneModels enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.high.floatValue > assertMax) {
            assertMax = obj.high.floatValue;
        }
        if (obj.low.floatValue < assertMin) {
            assertMin = obj.low.floatValue;
        }
        
        if(obj.MA_7)
        {
            if (obj.MA_7.floatValue > assertMax) {
                assertMax = obj.MA_7.floatValue;
            }
            if (obj.MA_7.floatValue < assertMin) {
                assertMin = obj.MA_7.floatValue;
            }
        }
        if(obj.MA_30)
        {
            if (obj.MA_30.floatValue > assertMax) {
                assertMax = obj.MA_30.floatValue;
            }
            if (obj.MA_30.floatValue < assertMin) {
                assertMin = obj.MA_30.floatValue;
            }
        }
    }];
    
    assertMin *= 0.9991;
    assertMax *= 1.0001;
    
    CGFloat yMin = MTCurveChartKLineMainViewMinY;
    CGFloat yMax = self.frame.size.height - 15;
    CGFloat unitY = (assertMax - assertMin) / (yMax - yMin);
    
    [self.needDrawPositionModels removeAllObjects];
    [self.MA7Positions removeAllObjects];
    [self.MA30Positions removeAllObjects];
    
    [self.needDrawKlneModels enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SJKlineModel *kLineModel = obj;
        
        CGFloat ponitX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGPoint openPoint = CGPointMake(ponitX, ABS(yMax - (kLineModel.open.floatValue - assertMin) / unitY));
        CGPoint closePoint = CGPointMake(ponitX, ABS(yMax - (kLineModel.close.floatValue - assertMin) / unitY));
        CGPoint highPoint = CGPointMake(ponitX, ABS(yMax - (kLineModel.high.floatValue - assertMin) / unitY));
        CGPoint lowPoint = CGPointMake(ponitX, ABS(yMax - (kLineModel.low.floatValue - assertMin) / unitY));
        MTKLinePositionModel *positionModel = [[MTKLinePositionModel alloc] init];
        positionModel.openPoint = openPoint;
        positionModel.closePoint = closePoint;
        positionModel.highPoint = highPoint;
        positionModel.lowPoint = lowPoint;
        [self.needDrawPositionModels addObject:positionModel];
        
        //MA坐标转换
        CGFloat ma7Y = yMax;
        CGFloat ma30Y = yMin;
        if(kLineModel.MA_7)
        {
            ma7Y = yMax - (kLineModel.MA_7.floatValue - assertMin) / unitY;
        }
        if(kLineModel.MA_30)
        {
            ma30Y = yMax - (kLineModel.MA_30.floatValue - assertMin) / unitY;
        }
        CGPoint ma7Point = CGPointMake(ponitX, ma7Y);
        CGPoint ma30Point = CGPointMake(ponitX, ma30Y);
        
        [self.MA7Positions addObject:[NSValue valueWithCGPoint:ma7Point]];
        [self.MA30Positions addObject:[NSValue valueWithCGPoint:ma30Point]];
    }];
    
    [self setNeedsDisplay];
}

@end
