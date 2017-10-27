//
//  MTTechVolumeView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechVolumeView.h"
#import "SJKlineModel.h"
#import "SJCurveChartConstant.h"
#import "MTVolumePositionModel.h"
#import "MTCurveChartGlobalVariable.h"
#import "UIColor+CurveChart.h"
#import "MTMALine.h"
#import "MTVolume.h"
#import "MTVolumePositionModel.h"
#import "MTShowDetailsView.h"

@interface MTTechVolumeView ()
@property (nonatomic, strong) MTShowDetailsView *showDetailsView;
/**
 *  volume位置数组
 */
@property (nonatomic, strong) NSMutableArray *volumePositions;
/**
 *  volumeMA5位置数组
 */
@property (nonatomic, strong) NSMutableArray *volumeMA5Positions;
/**
 *  volumeMA10位置数组
 */
@property (nonatomic, strong) NSMutableArray *volumeMA10Positions;
/**
 *  volumeMA20位置数组
 */
@property (nonatomic, strong) NSMutableArray *volumeMA20Positions;
@end

@implementation MTTechVolumeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.volumePositions = @[].mutableCopy;
        self.volumeMA5Positions = @[].mutableCopy;
        self.volumeMA10Positions = @[].mutableCopy;
        self.volumeMA20Positions = @[].mutableCopy;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGrid:context];
    
    [self drawTopdeTailsView];
    
    [self drawVolume:context];
    
    [self drawMA:context];
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [MTCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawVolume:(CGContextRef)context {
    if (self.volumePositions.count > 0) {
        MTVolume *volume = [[MTVolume alloc] initWithContext:context];
        [self.volumePositions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MTVolumePositionModel *volumePositionModel = (MTVolumePositionModel *)obj;
            volume.positionModel = volumePositionModel;
            [volume draw];
        }];
    }
}

- (void)drawMA:(CGContextRef)context {
    MTMALine *MALine = [[MTMALine alloc] initWithContext:context];
    MALine.techType = SJCurveTechType_Volume;
    if (self.volumeMA5Positions.count > 0) {
        MALine.MAType = MT_MA5Type;
        MALine.MAPositions = self.volumeMA5Positions;
        [MALine draw];
    }
    if (self.volumeMA10Positions.count > 0) {
        MALine.MAType = MT_MA10Type;
        MALine.MAPositions = self.volumeMA10Positions;
        [MALine draw];
    }
    if (self.volumeMA20Positions.count > 0) {
        MALine.MAType = MT_MA20Type;
        MALine.MAPositions = self.volumeMA20Positions;
        [MALine draw];
    }
}

- (void)drawTopdeTailsView {
    NSDictionary *volumeDic = @{
                                @"content" : [NSString stringWithFormat:@"%.2f", self.showKlineModel.volume.floatValue],
                                @"color":[UIColor assistTextColor],
                                @"type":@"2"
                                };
    NSDictionary *MA5Dic = @{
                             @"content" : [NSString stringWithFormat:@"MA5:%.2f", self.showKlineModel.volumeMA_5.floatValue],
                             @"color":[UIColor MTCurveVioletColor],
                             @"type":@"1"
                             };
    NSDictionary *MA10Dic = @{
                              @"content" : [NSString stringWithFormat:@"MA10:%.2f", self.showKlineModel.volumeMA_10.floatValue],
                              @"color":[UIColor MTCurveYellowColor],
                              @"type":@"1"
                              };
    NSDictionary *MA20Dic = @{
                              @"content" : [NSString stringWithFormat:@"MA20:%.2f", self.showKlineModel.volumeMA_20.floatValue],
                              @"color":[UIColor MTCurveBlueColor],
                              @"type":@"1"
                              };
    NSArray *contentAarray = [NSArray arrayWithObjects:volumeDic, MA5Dic, MA10Dic,MA20Dic, nil];
    [self.showDetailsView redrawWithArray:contentAarray];
}

#pragma mark -
- (void)drawTechView {
    [super drawTechView];
    //重新绘制成交量的视图
    [self convertToVolumePositionModelWithKLineModels];
    
    self.showKlineModel = self.needDrawVolumeModels.lastObject;
    
    [self setNeedsDisplay];
}

- (void)reDrawShowViewWithIndex:(NSInteger)index {
    if (index == -1) {
        self.showKlineModel = self.needDrawVolumeModels.lastObject;
        [self drawTopdeTailsView];
    } else if (index < self.needDrawVolumeModels.count && index > 0) {
        self.showKlineModel = self.needDrawVolumeModels[index];
        [self drawTopdeTailsView];
    }
}

#pragma mark -
//把需要绘制的KLineModel转换成对应屏幕坐标model
- (void)convertToVolumePositionModelWithKLineModels {
    if (!self.needDrawVolumeModels) {
        return;
    }
    
    if (![self lookupKlineDataMaxAndMin]) {
        return;
    }
    
    //计算视图上单位距离对应的成交量数值
    self.unitValue = (self.currentValueMax - self.currentValueMin) / (self.currentValueMaxToViewY - self.currentValueMinToViewY);
    
    //移除旧的值
    [self.volumePositions removeAllObjects];
    [self.volumeMA5Positions removeAllObjects];
    [self.volumeMA10Positions removeAllObjects];
    [self.volumeMA20Positions removeAllObjects];
    
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(SJKlineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.unitValue <= 0.0000001) {
            *stop = YES;
        }
        
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGFloat yPosition = ABS(self.currentValueMaxToViewY - (model.volume.floatValue - self.currentValueMin)/self.self.unitValue);
        
        CGPoint volumePoint = CGPointMake(ponitScreenX, yPosition);
        
        CGPoint startPoint = CGPointMake(ponitScreenX, MTCurveChartKLineVolumeViewMaxY);
        MTVolumePositionModel *volumePositionModel = [[MTVolumePositionModel alloc] init];
        volumePositionModel.volumePoint = volumePoint;
        volumePositionModel.startPoint = startPoint;
        volumePositionModel.color = model.open.floatValue < model.close.floatValue ? [UIColor increaseColor] : [UIColor decreaseColor];
        [self.volumePositions addObject:volumePositionModel];
        
        //MA坐标转换
        CGFloat ma5ScreenY = self.currentValueMaxToViewY;
        CGFloat ma10ScreenY = self.currentValueMaxToViewY;
        CGFloat ma20ScreenY = self.currentValueMaxToViewY;
        
        if(model.volumeMA_5.floatValue != MTCurveChartFloatMax)
        {
            ma5ScreenY = self.currentValueMaxToViewY - (model.volumeMA_5.floatValue - self.currentValueMin)/self.unitValue;
        }
        if(model.volumeMA_10.floatValue != MTCurveChartFloatMax)
        {
            ma10ScreenY = self.currentValueMaxToViewY - (model.volumeMA_10.floatValue - self.currentValueMin)/self.unitValue;
        }
        if(model.volumeMA_20.floatValue != MTCurveChartFloatMax)
        {
            ma20ScreenY = self.currentValueMaxToViewY - (model.volumeMA_20.floatValue - self.currentValueMin)/self.unitValue;
        }
        
        NSAssert(!isnan(ma5ScreenY) && !isnan(ma10ScreenY) && !isnan(ma20ScreenY), @"出现NAN值");
        
        CGPoint ma5ScreenPoint = CGPointMake(ponitScreenX, ma5ScreenY);
        CGPoint ma10ScreenPoint = CGPointMake(ponitScreenX, ma10ScreenY);
        CGPoint ma20ScreenPoint = CGPointMake(ponitScreenX, ma20ScreenY);
        
        [self.volumeMA5Positions addObject: [NSValue valueWithCGPoint: ma5ScreenPoint]];
        [self.volumeMA10Positions addObject: [NSValue valueWithCGPoint: ma10ScreenPoint]];
        [self.volumeMA20Positions addObject: [NSValue valueWithCGPoint: ma20ScreenPoint]];
    }];
}
- (BOOL)lookupKlineDataMaxAndMin {
    if (self.needDrawVolumeModels.count <= 0) {
        return NO;
    }
    
    __block CGFloat minVolume = MTCurveChartFloatMax;
    __block CGFloat maxVolume = MTCurveChartFloatMin;
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(SJKlineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.volume.floatValue < minVolume)
        {
            minVolume = model.volume.floatValue;
        }
        
        if(model.volume.floatValue > maxVolume)
        {
            maxVolume = model.volume.floatValue;
        }
        if(model.volumeMA_5.floatValue != MTCurveChartFloatMax)
        {
            if (minVolume > model.volumeMA_5.floatValue) {
                minVolume = model.volumeMA_5.floatValue;
            }
            if (maxVolume < model.volumeMA_5.floatValue) {
                maxVolume = model.volumeMA_5.floatValue;
            }
        }
        if(model.volumeMA_10.floatValue != MTCurveChartFloatMax)
        {
            if (minVolume > model.volumeMA_10.floatValue) {
                minVolume = model.volumeMA_10.floatValue;
            }
            if (maxVolume < model.volumeMA_10.floatValue) {
                maxVolume = model.volumeMA_10.floatValue;
            }
        }
        if(model.volumeMA_20.floatValue != MTCurveChartFloatMax)
        {
            if (minVolume > model.volumeMA_20.floatValue) {
                minVolume = model.volumeMA_20.floatValue;
            }
            if (maxVolume < model.volumeMA_20.floatValue) {
                maxVolume = model.volumeMA_20.floatValue;
            }
        }
    }];
    
    self.currentValueMin = minVolume;
    self.currentValueMax = maxVolume;
    
    return YES;
}

#pragma mark -
- (MTShowDetailsView *)showDetailsView {
    if (!_showDetailsView) {
        _showDetailsView = [[MTShowDetailsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        [self addSubview:_showDetailsView];
    }
    
    return _showDetailsView;
}

@end


