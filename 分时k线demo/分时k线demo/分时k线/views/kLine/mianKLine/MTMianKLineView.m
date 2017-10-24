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

// 当前价格最大值
@property (nonatomic, assign) CGFloat currentPriceMax;
// 当前价格最小值
@property (nonatomic, assign) CGFloat currentPriceMin;
// 当前价格最大值对应到视图上的纵坐标
@property (nonatomic, assign) CGFloat currentPriceMaxToViewY;
// 当前价格最小值对应到视图上的纵坐标
@property (nonatomic, assign) CGFloat currentPriceMinToViewY;
//视图上单位坐标表示的价格值
@property (nonatomic, assign) CGFloat unitViewY;

@end

@implementation MTMianKLineView
- (instancetype)initWithDelegate:(id<MTMianKLineViewDelegate>)delegate {
    if (self = [super init]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.delegate = delegate;
        self.needDrawPositionModels = @[].mutableCopy;
        self.MA5Positions = @[].mutableCopy;
        self.MA10Positions = @[].mutableCopy;
        self.MA20Positions = @[].mutableCopy;
        self.currentPriceMax = 0;
        self.currentPriceMin = 0;
        self.currentPriceMinToViewY = 0;
        self.currentPriceMaxToViewY = self.frame.size.height;
        self.unitViewY = 0.0f;
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
    
    [self drawPositionYRuler:context];//绘制y轴尺标
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
    
    const CGPoint gridKlinePoints5[] = {CGPointMake(0, self.currentPriceMaxToViewY), CGPointMake(self.bounds.size.width, self.currentPriceMaxToViewY)};
    CGContextStrokeLineSegments(context, gridKlinePoints5, 2);
    const CGPoint gridKlinePoints6[] = {CGPointMake(0, self.currentPriceMinToViewY), CGPointMake(self.bounds.size.width, self.currentPriceMinToViewY)};
    CGContextStrokeLineSegments(context, gridKlinePoints6, 2);
    
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

- (void)drawPositionYRuler:(CGContextRef)context {
    // 同样先全部写死，看看效果，后面根据需求更改
    CGFloat unitValueY = (self.currentPriceMax - self.currentPriceMin) / 3;
    CGFloat rulerValueY0 = self.currentPriceMin;
    CGFloat rulerValueY1 = self.currentPriceMin + unitValueY;
    CGFloat rulerValueY2 = self.currentPriceMin + unitValueY * 2;
    CGFloat rulerValueY3 = self.currentPriceMax;
    NSArray *rulerValueYs = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f", rulerValueY0] ,[NSString stringWithFormat:@"%.2f", rulerValueY1], [NSString stringWithFormat:@"%.2f",rulerValueY2], [NSString stringWithFormat:@"%.2f", rulerValueY3], nil];
    CGFloat unitPositionYRuler = self.frame.size.height / 3;
    for (NSInteger i = 0; i < rulerValueYs.count ; i++) {
        NSString *positionYStr = rulerValueYs[rulerValueYs.count - i - 1];
        CGPoint drawTitlePoint = CGPointMake(0, unitPositionYRuler * i);
        if (i == 3) {
            drawTitlePoint = CGPointMake(0, unitPositionYRuler * i - 15);
        }
        
        [positionYStr drawAtPoint:drawTitlePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor mainTextColor]}];
    }
}

- (void)reDrawShowViewWithIndex:(NSInteger)index {
    if (index < self.needDrawKlneModels.count && index > 0) {
        self.showKlineModel = self.needDrawKlneModels[index];
        [self drawTopdeTailsView];
    }
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
- (void)getExactPositionWithOriginPosition:(CGPoint)longPressPosition{
    CGFloat xPositoinInMainView = longPressPosition.x;
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
        
        
        //调用代理，通知指标view更新详情信息
        if (self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressExactPosition:selectedIndex:longPressPrice:)]) {
            CGFloat longPressPrece = self.unitViewY * (self.currentPriceMaxToViewY - longPressPosition.y) + self.currentPriceMin;
            [self.delegate kLineMainViewLongPressExactPosition:CGPointMake(exactXPositionInMainView, longPressPosition.y) selectedIndex:index longPressPrice:longPressPrece];
        }
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
    
    self.currentPriceMinToViewY = MTCurveChartKLineMainViewMinY;
    self.currentPriceMaxToViewY = self.frame.size.height - MTCurveChartKLineMainViewMinY;
    
    //计算view上单位距离对应的数据值
    self.unitViewY = (self.currentPriceMax - self.currentPriceMin) / (self.currentPriceMaxToViewY - self.currentPriceMinToViewY);
    
    //移除旧的值
    [self.needDrawPositionModels removeAllObjects];
    [self.MA5Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA20Positions removeAllObjects];
    
    //计算需要实现的数据对应到屏幕上的坐标
    [self.needDrawKlneModels enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SJKlineModel *kLineModel = obj;
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        
        CGPoint openPoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.open.floatValue - self.currentPriceMin) / self.unitViewY));
        CGPoint closePoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.close.floatValue - self.currentPriceMin) / self.unitViewY));
        CGPoint highPoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.high.floatValue - self.currentPriceMin) / self.unitViewY));
        CGPoint lowPoint = CGPointMake(ponitScreenX, ABS(self.currentPriceMaxToViewY - (kLineModel.low.floatValue - self.currentPriceMin) / self.unitViewY));
        MTKLinePositionModel *positionModel = [[MTKLinePositionModel alloc] init];
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
            ma5ScreenY = self.currentPriceMaxToViewY - (kLineModel.MA_5.floatValue - self.currentPriceMin) / self.unitViewY;
        }
        if(kLineModel.MA_20)
        {
            ma20ScreenY = self.currentPriceMaxToViewY - (kLineModel.MA_20.floatValue - self.currentPriceMin) / self.unitViewY;
        }
        if (kLineModel.MA_10) {
            ma10ScreenY = self.currentPriceMaxToViewY - (kLineModel.MA_10.floatValue - self.currentPriceMin) / self.unitViewY;
        }
        CGPoint ma5ScreenPoint = CGPointMake(ponitScreenX, ma5ScreenY);
        CGPoint ma10ScreenPoint = CGPointMake(ponitScreenX, ma10ScreenY);
        CGPoint ma20ScreenPoint = CGPointMake(ponitScreenX, ma20ScreenY);
        
        [self.MA5Positions addObject:[NSValue valueWithCGPoint:ma5ScreenPoint]];
        [self.MA10Positions addObject:[NSValue valueWithCGPoint:ma10ScreenPoint]];
        [self.MA20Positions addObject:[NSValue valueWithCGPoint:ma20ScreenPoint]];
    }];
}

- (BOOL)lookupKlineDataMaxAndMin {
    if (self.needDrawKlneModels.count <= 0) {
        return NO;
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
    
    self.currentPriceMin = assertMin;
    self.currentPriceMax = assertMax;
    
    return YES;
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
