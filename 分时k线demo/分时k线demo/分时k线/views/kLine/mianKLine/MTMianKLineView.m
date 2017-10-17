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
#import "MTKlineShowView.h"

@interface MTMianKLineView ()
//
@property (nonatomic, strong) NSMutableArray<MTKLinePositionModel *> *needDrawPositionModels;
@property (nonatomic, strong) MTKlineShowView *kLineShowView;
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
    NSString *titleStr = [NSString stringWithFormat:@"MA5 %.2f  MA10 %.2f  MA20 %.2f", self.showKlineModel.MA_5.floatValue, self.showKlineModel.MA_10.floatValue, self.showKlineModel.MA_20.floatValue];
    [self.kLineShowView redrawWithString:titleStr];
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
    
    self.showKlineModel = self.needDrawKlneModels.lastObject;
    
    [self setNeedsDisplay];
}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition {
    CGFloat xPositoinInMainView = originXPosition;
    CGFloat exactXPositionInMainView = 0.0;
    
    //原始的x位置获取对应在数组中的index
    NSInteger index = xPositoinInMainView / ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    //对应index映射到view上的准确位置
    CGFloat indexXPosition = index * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    //最小临界值
    CGFloat minX = indexXPosition  - ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]) / 2;
    //最大临界值
    CGFloat maxX = indexXPosition + ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]) / 2;
    //对比原始x值大于最小临界值，并小于最大临界值，返回当前index的精确位置;当大于最大临界值时，返回下一个index对应的精确位置(理论上该值不可能小于最小临界值，所以不用考虑)
    if (xPositoinInMainView < maxX && xPositoinInMainView > minX) {
        exactXPositionInMainView = indexXPosition;
    } else {
        index++;
        exactXPositionInMainView = indexXPosition + ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
    }
    
    //显示长按点的k线详情信息
    if (index < self.needDrawKlneModels.count && index > 0) {
        self.showKlineModel = self.needDrawKlneModels[index];
        NSString *titleStr = [NSString stringWithFormat:@"MA5 %.2f  MA10 %.2f  MA20 %.2f", self.showKlineModel.MA_5.floatValue, self.showKlineModel.MA_10.floatValue, self.showKlineModel.MA_20.floatValue];
        [self.kLineShowView redrawWithString:titleStr];
    }
    
    //调用代理，通知指标view更新详情信息
    if (self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPress:)]) {
        [self.delegate kLineMainViewLongPress:index];
    }
    
    return indexXPosition;
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

#pragma mark - 
- (MTKlineShowView *)kLineShowView {
    if (!_kLineShowView) {
        _kLineShowView = [[MTKlineShowView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self addSubview:_kLineShowView];
    }
    
    return _kLineShowView;
}

@end
