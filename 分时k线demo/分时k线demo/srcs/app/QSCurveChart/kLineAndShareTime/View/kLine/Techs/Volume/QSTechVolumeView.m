//
//  QSTechVolumeView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechVolumeView.h"
#import "QSKlineModel.h"
#import "QSConstant.h"
#import "QSVolumePositionModel.h"
#import "QSCurveChartGlobalVariable.h"
#import "UIColor+CurveChart.h"
#import "QSMALine.h"
#import "QSVolume.h"
#import "QSVolumePositionModel.h"
#import "QSShowDetailsView.h"

@interface QSTechVolumeView ()
@property (nonatomic, strong) QSShowDetailsView *showDetailsView;
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

@implementation QSTechVolumeView
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
    CGFloat gridLineWidth = [QSCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawVolume:(CGContextRef)context {
    if (self.volumePositions.count > 0) {
        QSVolume *volume = [[QSVolume alloc] initWithContext:context];
        [self.volumePositions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QSVolumePositionModel *volumePositionModel = (QSVolumePositionModel *)obj;
            volume.positionModel = volumePositionModel;
            [volume draw];
        }];
    }
}

- (void)drawMA:(CGContextRef)context {
    QSMALine *MALine = [[QSMALine alloc] initWithContext:context];
    MALine.techType = QSCurveTechType_Volume;
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
                                @"content" : [NSString stringWithFormat:@"%.2f", self.showKlineModel.volume],
                                @"color":[UIColor assistTextColor],
                                @"type":@"2"
                                };
    NSDictionary *MA5Dic = @{
                             @"content" : [NSString stringWithFormat:@"MA5:%.2f", self.showKlineModel.volumeMA_5],
                             @"color":[UIColor MTCurveVioletColor],
                             @"type":@"1"
                             };
    NSDictionary *MA10Dic = @{
                              @"content" : [NSString stringWithFormat:@"MA10:%.2f", self.showKlineModel.volumeMA_10],
                              @"color":[UIColor MTCurveYellowColor],
                              @"type":@"1"
                              };
    NSDictionary *MA20Dic = @{
                              @"content" : [NSString stringWithFormat:@"MA20:%.2f", self.showKlineModel.volumeMA_20],
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
    
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(QSKlineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat ponitScreenX = idx * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
        CGFloat yPosition = ABS(self.currentValueMaxToViewY - (model.volume - self.currentValueMin)/self.self.unitValue);
        
        CGPoint volumePoint = CGPointMake(ponitScreenX, yPosition);
        
        CGPoint startPoint = CGPointMake(ponitScreenX, QSCurveChartKLineVolumeViewMaxY);
        QSVolumePositionModel *volumePositionModel = [[QSVolumePositionModel alloc] init];
        volumePositionModel.volumePoint = volumePoint;
        volumePositionModel.startPoint = startPoint;
        volumePositionModel.color = model.open < model.close ? [UIColor increaseColor] : [UIColor decreaseColor];
        [self.volumePositions addObject:volumePositionModel];
        
        //MA坐标转换
        CGFloat ma5ScreenY = self.currentValueMaxToViewY;
        CGFloat ma10ScreenY = self.currentValueMaxToViewY;
        CGFloat ma20ScreenY = self.currentValueMaxToViewY;
        if(self.unitValue > 0.0000001)
        {
            if(model.volumeMA_5)
            {
                ma5ScreenY = self.currentValueMaxToViewY - (model.volumeMA_5 - self.currentValueMin)/self.unitValue;
            }
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.volumeMA_10)
            {
                ma10ScreenY = self.currentValueMaxToViewY - (model.volumeMA_10 - self.currentValueMin)/self.unitValue;
            }
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.volumeMA_20)
            {
                ma20ScreenY = self.currentValueMaxToViewY - (model.volumeMA_20 - self.currentValueMin)/self.unitValue;
            }
        }
        
        NSAssert(!isnan(ma5ScreenY) && !isnan(ma10ScreenY) && !isnan(ma20ScreenY), @"出现NAN值");
        
        CGPoint ma5ScreenPoint = CGPointMake(ponitScreenX, ma5ScreenY);
        CGPoint ma10ScreenPoint = CGPointMake(ponitScreenX, ma10ScreenY);
        CGPoint ma20ScreenPoint = CGPointMake(ponitScreenX, ma20ScreenY);
        if(model.volumeMA_5)
        {
            [self.volumeMA5Positions addObject: [NSValue valueWithCGPoint: ma5ScreenPoint]];
        }
        if(model.volumeMA_10)
        {
            [self.volumeMA10Positions addObject: [NSValue valueWithCGPoint: ma10ScreenPoint]];
        }
        if(model.volumeMA_20)
        {
            [self.volumeMA20Positions addObject: [NSValue valueWithCGPoint: ma20ScreenPoint]];
        }
    }];
}
- (BOOL)lookupKlineDataMaxAndMin {
    if (self.needDrawVolumeModels.count <= 0) {
        return NO;
    }
    
    QSKlineModel *firstModel = self.needDrawVolumeModels.firstObject;
    __block CGFloat minVolume = firstModel.volume;
    __block CGFloat maxVolume = firstModel.volume;
    [self.needDrawVolumeModels enumerateObjectsUsingBlock:^(QSKlineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.volume < minVolume)
        {
            minVolume = model.volume;
        }
        
        if(model.volume > maxVolume)
        {
            maxVolume = model.volume;
        }
        if(model.volumeMA_5)
        {
            if (minVolume > model.volumeMA_5) {
                minVolume = model.volumeMA_5;
            }
            if (maxVolume < model.volumeMA_5) {
                maxVolume = model.volumeMA_5;
            }
        }
        if(model.volumeMA_10)
        {
            if (minVolume > model.volumeMA_10) {
                minVolume = model.volumeMA_10;
            }
            if (maxVolume < model.volumeMA_10) {
                maxVolume = model.volumeMA_10;
            }
        }
        if(model.volumeMA_20)
        {
            if (minVolume > model.volumeMA_20) {
                minVolume = model.volumeMA_20;
            }
            if (maxVolume < model.volumeMA_20) {
                maxVolume = model.volumeMA_20;
            }
        }
    }];
    
    self.currentValueMin = minVolume;
    self.currentValueMax = maxVolume;
    
    return YES;
}

#pragma mark -

- (QSShowDetailsView *)showDetailsView {
    if (!_showDetailsView) {
        _showDetailsView = [[QSShowDetailsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        [self addSubview:_showDetailsView];
    }
    
    return _showDetailsView;
}

@end
