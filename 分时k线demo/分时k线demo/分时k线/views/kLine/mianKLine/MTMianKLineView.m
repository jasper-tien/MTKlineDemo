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
 *  MA5位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA5Positions;
/**
 *  MA10位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA10Positions;

/**
 *  MA20位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA20Positions;

@end

@implementation MTMianKLineView
- (instancetype)initWithDelegate:(id<MTMianKLineViewDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.needDrawPositionModels = @[].mutableCopy;
        self.MA5Positions = @[].mutableCopy;
        self.MA10Positions = @[].mutableCopy;
        self.MA20Positions = @[].mutableCopy;
        self.backgroundColor = [UIColor backgroundColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.needDrawPositionModels.count <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGrid:context];//绘制框
    
    [self drawTopdeTailsView];//绘制顶部详情信息
    
    [self drawCandle:context];//绘制蜡烛
    
    [self drawMA:context];//绘制均线
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [MTCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2*gridLineWidth));
    CGContextStrokePath(context);
    
    //先写死两条横线位置看看效果
    CGContextSetLineWidth(context, [MTCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints1[] = {CGPointMake(0, self.bounds.size.height * 1 / 3), CGPointMake(self.bounds.size.width, self.bounds.size.height * 1 / 3)};
    CGContextStrokeLineSegments(context, gridKlinePoints1, 2);
    CGContextSetLineWidth(context, [MTCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints2[] = {CGPointMake(0, self.bounds.size.height * 2 / 3), CGPointMake(self.bounds.size.width, self.bounds.size.height * 2 / 3)};
    CGContextStrokeLineSegments(context, gridKlinePoints2, 2);
    
    //先写死两条竖线位置看看效果
    CGContextSetLineWidth(context, [MTCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints3[] = {CGPointMake(self.bounds.size.width * 1 / 3, 0), CGPointMake(self.bounds.size.width * 1 / 3, self.bounds.size.height)};
    CGContextStrokeLineSegments(context, gridKlinePoints3, 2);
    CGContextSetLineWidth(context, [MTCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints4[] = {CGPointMake(self.bounds.size.width * 2 / 3, 0), CGPointMake(self.bounds.size.width * 2 / 3, self.bounds.size.height)};
    CGContextStrokeLineSegments(context, gridKlinePoints4, 2);
}

- (void)drawTopdeTailsView {
    SJKlineModel *lastModel = self.needDrawKlneModels.lastObject;
    NSString *titleStr = [NSString stringWithFormat:@"MA5 %.2f  MA10 %.2f  MA20 %.2f", lastModel.MA_5.floatValue, lastModel.MA_10.floatValue, lastModel.MA_20.floatValue];
    CGPoint drawTitlePoint = CGPointMake(5, 0);
    [titleStr drawAtPoint:drawTitlePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
}

- (void)drawCandle:(CGContextRef)context {
    MTKLine *kLine = [[MTKLine alloc] initWithContext:context];
    [self.needDrawPositionModels enumerateObjectsUsingBlock:^(MTKLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTKLinePositionModel *positionModel = obj;
        kLine.positionModel = positionModel;
        [kLine draw];
    }];
}

- (void)drawMA:(CGContextRef)context {
    MTMALine *MALine = [[MTMALine alloc] initWithContext:context];
    MALine.techType = SJCurveTechType_KLine;
    MALine.MAType = MT_MA5Type;
    MALine.MAPositions = self.MA5Positions;
    [MALine draw];
    
    MALine.MAType = MT_MA10Type;
    MALine.MAPositions = self.MA10Positions;
    [MALine draw];
    
    MALine.MAType = MT_MA20Type;
    MALine.MAPositions = self.MA20Positions;
    [MALine draw];
}

#pragma mark -
- (void)drawMainView {
    [self convertToKLinePositionModelWithKLineModels];
    
    [self setNeedsDisplay];
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
        
        if(obj.MA_5)
        {
            if (obj.MA_5.floatValue > assertMax) {
                assertMax = obj.MA_5.floatValue;
            }
            if (obj.MA_5.floatValue < assertMin) {
                assertMin = obj.MA_5.floatValue;
            }
        }
        if(obj.MA_10)
        {
            if (obj.MA_10.floatValue > assertMax) {
                assertMax = obj.MA_10.floatValue;
            }
            if (obj.MA_5.floatValue < assertMin) {
                assertMin = obj.MA_10.floatValue;
            }
        }
        if(obj.MA_20)
        {
            if (obj.MA_20.floatValue > assertMax) {
                assertMax = obj.MA_20.floatValue;
            }
            if (obj.MA_30.floatValue < assertMin) {
                assertMin = obj.MA_20.floatValue;
            }
        }
    }];
    
    assertMin *= 0.9991;
    assertMax *= 1.0001;
    
    CGFloat yMin = MTCurveChartKLineMainViewMinY;
    CGFloat yMax = self.frame.size.height - 15;
    CGFloat unitY = (assertMax - assertMin) / (yMax - yMin);
    
    [self.needDrawPositionModels removeAllObjects];
    [self.MA5Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA20Positions removeAllObjects];
    
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
        CGFloat ma5Y = yMax;
        CGFloat ma10Y = yMax;
        CGFloat ma20Y = yMax;
        if(kLineModel.MA_5)
        {
            ma5Y = yMax - (kLineModel.MA_5.floatValue - assertMin) / unitY;
        }
        if(kLineModel.MA_20)
        {
            ma20Y = yMax - (kLineModel.MA_20.floatValue - assertMin) / unitY;
        }
        if (kLineModel.MA_10) {
            ma10Y = yMax - (kLineModel.MA_10.floatValue - assertMin) / unitY;
        }
        CGPoint ma5Point = CGPointMake(ponitX, ma5Y);
        CGPoint ma10Point = CGPointMake(ponitX, ma10Y);
        CGPoint ma20Point = CGPointMake(ponitX, ma20Y);
        
        [self.MA5Positions addObject:[NSValue valueWithCGPoint:ma5Point]];
        [self.MA10Positions addObject:[NSValue valueWithCGPoint:ma10Point]];
        [self.MA20Positions addObject:[NSValue valueWithCGPoint:ma20Point]];
    }];
}

@end
