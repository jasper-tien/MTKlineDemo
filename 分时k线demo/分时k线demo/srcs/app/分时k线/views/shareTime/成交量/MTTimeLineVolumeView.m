//
//  MTTimeLineVolumeView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTimeLineVolumeView.h"
#import "MTTimeLineModel.h"
#import "MTCurveChartGlobalVariable.h"
#import "MTVolumePositionModel.h"
#import "SJCurveChartConstant.h"
#import "UIColor+CurveChart.h"
#import "MTVolumePositionModel.h"

@interface MTTimeLineVolumeView ()
/**
 *  volume位置数组
 */
@property (nonatomic, strong) NSMutableArray *volumePositions;
//视图view上单位距离对应的数值
@property (nonatomic, assign) CGFloat unitValue;
// 当前最大值
@property (nonatomic, assign) CGFloat currentValueMax;
// 当前最小值
@property (nonatomic, assign) CGFloat currentValueMin;
//当前最大值对应到视图上的纵坐标
@property (nonatomic, assign) CGFloat currentValueMaxToViewY;
//当前最小值对应到视图上的纵坐标
@property (nonatomic, assign) CGFloat currentValueMinToViewY;
@end

@implementation MTTimeLineVolumeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.volumePositions = @[].mutableCopy;
        self.currentValueMin = 0;
        self.currentValueMax = 0;
        self.currentValueMinToViewY = 0;
        self.currentValueMaxToViewY = self.frame.size.height;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.volumePositions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTVolumePositionModel *positionModel = obj;
        CGContextSetStrokeColorWithColor(context, [UIColor MTTimeLineColor].CGColor);
        //画中间开盘和收盘实体线
        CGContextSetLineWidth(context, [MTCurveChartGlobalVariable timeLineVolumeWidth]);
        const CGPoint solidPoints[] = {positionModel.volumePoint, positionModel.startPoint};
        CGContextStrokeLineSegments(context, solidPoints, 2);
    }];
}

- (void)updateDrawModels {
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

#pragma mark -
//把需要绘制的KLineModel转换成对应屏幕坐标model
- (void)convertToVolumePositionModelWithKLineModels {
    if (![self lookupKlineDataMaxAndMin]) {
        return;
    }
    
    //计算视图上单位距离对应的成交量数值
    self.unitValue = (self.currentValueMax - self.currentValueMin) / (self.currentValueMaxToViewY - self.currentValueMinToViewY);
    
    //移除旧的值
    [self.volumePositions removeAllObjects];
    
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(MTTimeLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
        CGFloat yPosition = ABS(self.currentValueMaxToViewY - (model.Volume - self.currentValueMin)/self.self.unitValue);
        
        CGPoint volumePoint = CGPointMake(ponitScreenX, yPosition);
        
        CGPoint startPoint = CGPointMake(ponitScreenX, MTCurveChartKLineVolumeViewMaxY);
        MTVolumePositionModel *volumePositionModel = [[MTVolumePositionModel alloc] init];
        volumePositionModel.volumePoint = volumePoint;
        volumePositionModel.startPoint = startPoint;
        volumePositionModel.color = [UIColor decreaseColor];
        [self.volumePositions addObject:volumePositionModel];
    }];
}

- (BOOL)lookupKlineDataMaxAndMin {
    if (self.needDrawVolumeModels.count <= 0) {
        return NO;
    }
    
    MTTimeLineModel *firstModel = self.needDrawVolumeModels.firstObject;
    __block CGFloat minVolume = firstModel.Volume;
    __block CGFloat maxVolume = firstModel.Volume;
    
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(MTTimeLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.Volume < minVolume)
        {
            minVolume = model.Volume;
        }
        
        if(model.Volume > maxVolume)
        {
            maxVolume = model.Volume;
        }
    }];
    
    self.currentValueMin = minVolume;
    self.currentValueMax = maxVolume;
    return YES;
}

- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition {
    CGFloat xPositoinInMainView = longPressPosition.x;
    CGFloat exactXPositionInMainView = 0.0;
    
    //原始的x位置获取对应在数组中的index
    NSInteger index = xPositoinInMainView / ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
    //对应index映射到view上的准确位置
    CGFloat indexXPosition = index * ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
    //最小临界值
    CGFloat minX = indexXPosition  - ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]) / 2;
    //最大临界值
    CGFloat maxX = indexXPosition + ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]) / 2;
    //对比原始x值大于最小临界值，并小于最大临界值，返回当前index的精确位置;当大于最大临界值时，返回下一个index对应的精确位置(理论上该值不可能小于最小临界值，所以不用考虑)
    if (xPositoinInMainView < maxX && xPositoinInMainView > minX) {
        exactXPositionInMainView = indexXPosition;
    } else {
        index++;
        exactXPositionInMainView = indexXPosition + ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
    }
    
    //调用代理，通知指标view更新详情信息
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeLineVolumeViewLongPressExactPosition:selectedIndex:longPressVolume:)]) {
        CGFloat longPressPrece = self.unitValue * (self.currentValueMaxToViewY - longPressPosition.y) + self.currentValueMin;
        if (longPressPrece < self.currentValueMin) {
            longPressPrece = self.currentValueMin;
        }
        [self.delegate timeLineVolumeViewLongPressExactPosition:CGPointMake(exactXPositionInMainView, longPressPosition.y) selectedIndex:index longPressVolume:longPressPrece];
    }
}

@end
