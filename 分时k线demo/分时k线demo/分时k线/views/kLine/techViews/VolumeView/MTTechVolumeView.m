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
#import "MTTechsShowView.h"

@interface MTTechVolumeView ()
@property (nonatomic, strong) MTTechsShowView *volumeShowView;
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
    NSString *titleStr = [NSString stringWithFormat:@"  %.0f万手 MA5:%.2f MA10:%.2f MA20:%.2f", self.showKlineModel.volume.floatValue, self.showKlineModel.volumeMA_5.floatValue, self.showKlineModel.volumeMA_10.floatValue, self.showKlineModel.volumeMA_20.floatValue];
    [self.volumeShowView redrawWithString:titleStr];
}

#pragma mark -
- (void)drawTechView {
    [super drawTechView];
    //重新绘制成交量的视图
    [self convertToVolumePositionModelWithKLineModels];
    
    self.showKlineModel = self.needDrawVolumeModels.lastObject;
    
    [self setNeedsDisplay];
}

- (void)redrawShowViewWithIndex:(NSInteger)index {
    if (index < self.needDrawVolumeModels.count && index > 0) {
        self.showKlineModel = self.needDrawVolumeModels[index];
        NSString *titleStr = [NSString stringWithFormat:@"  %.0f万手 MA5:%.2f MA10:%.2f MA20:%.2f", self.showKlineModel.volume.floatValue, self.showKlineModel.volumeMA_5.floatValue, self.showKlineModel.volumeMA_10.floatValue, self.showKlineModel.volumeMA_20.floatValue];
        [self.volumeShowView redrawWithString:titleStr];
    }
}

#pragma mark -
//把需要绘制的KLineModel转换成对应屏幕坐标model
- (void)convertToVolumePositionModelWithKLineModels {
    if (!self.needDrawVolumeModels) {
        return;
    }
    
    CGFloat minY = MTCurveChartKLineVolumeViewMinY;
    CGFloat maxY = MTCurveChartKLineVolumeViewMaxY;
    
    SJKlineModel *firstModel = self.needDrawVolumeModels.firstObject;
    
    __block CGFloat minVolume = firstModel.volume.floatValue;
    __block CGFloat maxVolume = firstModel.volume.floatValue;
    
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(SJKlineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.volume.floatValue < minVolume)
        {
            minVolume = model.volume.floatValue;
        }
        
        if(model.volume.floatValue > maxVolume)
        {
            maxVolume = model.volume.floatValue;
        }
        if(model.volumeMA_5)
        {
            if (minVolume > model.volumeMA_5.floatValue) {
                minVolume = model.volumeMA_5.floatValue;
            }
            if (maxVolume < model.volumeMA_5.floatValue) {
                maxVolume = model.volumeMA_5.floatValue;
            }
        }
        if(model.volumeMA_10)
        {
            if (minVolume > model.volumeMA_10.floatValue) {
                minVolume = model.volumeMA_10.floatValue;
            }
            if (maxVolume < model.volumeMA_10.floatValue) {
                maxVolume = model.volumeMA_10.floatValue;
            }
        }
        if(model.volumeMA_20)
        {
            if (minVolume > model.volumeMA_20.floatValue) {
                minVolume = model.volumeMA_20.floatValue;
            }
            if (maxVolume < model.volumeMA_20.floatValue) {
                maxVolume = model.volumeMA_20.floatValue;
            }
        }
    }];
    
    self.unitValue = (maxVolume - minVolume) / (maxY - minY);
    [self.volumePositions removeAllObjects];
    [self.volumeMA5Positions removeAllObjects];
    [self.volumeMA10Positions removeAllObjects];
    [self.volumeMA20Positions removeAllObjects];
    
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(SJKlineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat xPosition = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGFloat yPosition = ABS(maxY - (model.volume.floatValue - minVolume)/self.self.unitValue);
        if(MTCurveChartKLineVolumeViewMaxY - yPosition < 20)
        {
            yPosition = MTCurveChartKLineVolumeViewMaxY - 19;
        }
        
        CGPoint volumePoint = CGPointMake(xPosition, yPosition);
        
        CGPoint startPoint = CGPointMake(xPosition, MTCurveChartKLineVolumeViewMaxY - 20);
        MTVolumePositionModel *volumePositionModel = [[MTVolumePositionModel alloc] init];
        volumePositionModel.volumePoint = volumePoint;
        volumePositionModel.startPoint = startPoint;
        volumePositionModel.color = model.open.floatValue < model.close.floatValue ? [UIColor increaseColor] : [UIColor decreaseColor];
        [self.volumePositions addObject:volumePositionModel];
        
        //MA坐标转换
        CGFloat ma5Y = maxY;
        CGFloat ma10Y = maxY;
        CGFloat ma20Y = maxY;
        if(self.unitValue > 0.0000001)
        {
            if(model.volumeMA_5)
            {
                ma5Y = maxY - (model.volumeMA_5.floatValue - minVolume)/self.unitValue;
            }
            
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.volumeMA_10)
            {
                ma10Y = maxY - (model.volumeMA_10.floatValue - minVolume)/self.unitValue;
            }
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.volumeMA_20)
            {
                ma20Y = maxY - (model.volumeMA_20.floatValue - minVolume)/self.unitValue;
            }
        }
        
        NSAssert(!isnan(ma5Y) && !isnan(ma10Y) && !isnan(ma20Y), @"出现NAN值");
        
        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        CGPoint ma20Point = CGPointMake(xPosition, ma20Y);
        if(model.volumeMA_5)
        {
            [self.volumeMA5Positions addObject: [NSValue valueWithCGPoint: ma5Point]];
        }
        if(model.volumeMA_10)
        {
            [self.volumeMA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
        }
        if(model.volumeMA_20)
        {
            [self.volumeMA20Positions addObject: [NSValue valueWithCGPoint: ma20Point]];
        }
    }];
}

#pragma mark -
- (MTTechsShowView *)volumeShowView {
    if (!_volumeShowView) {
        _volumeShowView = [[MTTechsShowView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self addSubview:_volumeShowView];
    }
    
    return _volumeShowView;
}

@end


