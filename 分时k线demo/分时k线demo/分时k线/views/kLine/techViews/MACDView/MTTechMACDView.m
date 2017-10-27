//
//  MTTechMACDView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/13.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechMACDView.h"
#import "MTCurveMACD.h"
#import "UIColor+CurveChart.h"
#import "SJCurveChartConstant.h"
#import "MTCurveChartGlobalVariable.h"
#import "MTMALine.h"
#import "MTMACDLine.h"
#import "MTShowDetailsView.h"

@interface MTTechMACDView ()
@property (nonatomic, strong) MTShowDetailsView *showDetailsView;
@property (nonatomic, strong) NSMutableArray *DIFPositionModels;
@property (nonatomic, strong) NSMutableArray *DEAPositionModels;
@property (nonatomic, strong) NSMutableArray *MACDPositionModels;
@property (nonatomic, assign) CGFloat zeroPointY;
@end

@implementation MTTechMACDView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.DIFPositionModels = @[].mutableCopy;
        self.DEAPositionModels = @[].mutableCopy;
        self.MACDPositionModels = @[].mutableCopy;
        self.zeroPointY = 0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawGrid:context];
    
    [self drawMACD:context];
    
    [self drawTopdeTailsView];
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [MTCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawMACD:(CGContextRef)context {
    MTMALine *MALine = [[MTMALine alloc] initWithContext:context];
    MALine.techType = SJCurveTechType_MACD;
    if (self.DIFPositionModels.count > 0) {
        MALine.MAPositions = self.DIFPositionModels;
        MALine.MAType = MT_MACD_DIF;
        [MALine draw];
    }
    if (self.DEAPositionModels.count > 0) {
        MALine.MAPositions = self.DEAPositionModels;
        MALine.MAType = MT_MACD_DEA;
        [MALine draw];
    }
    if (self.MACDPositionModels.count > 0) {
        MTMACDLine *MACDKline = [[MTMACDLine alloc] initWithContext:context];
        MACDKline.zeroPointY = self.zeroPointY;
        MACDKline.MACDPositions = self.MACDPositionModels;
        [MACDKline draw];
    }
}

- (void)drawTopdeTailsView {
    NSString *titleStr = [NSString stringWithFormat:@"MACD(12, 26, 9)"];
    NSDictionary *MACDDic = @{
                              @"content" : titleStr,
                              @"color":[UIColor assistTextColor],
                              @"type":@"2"
                              };
    NSArray *contentAarray = [NSArray arrayWithObjects:MACDDic, nil];
    [self.showDetailsView redrawWithArray:contentAarray];
}

#pragma mark -
- (void)drawTechView {
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

- (void)reDrawShowViewWithIndex:(NSInteger)index {
    if (index == -1) {
        [self drawTopdeTailsView];
    } else if (index < self.needDrawMACDModels.count && index > 0) {
        self.showMACDModel = self.needDrawMACDModels[index];
        NSDictionary *DIFDic = @{
                                @"content" : [NSString stringWithFormat:@"DIF:%.2f", self.showMACDModel.DIF.floatValue],
                                @"color":[UIColor MTCurveYellowColor],
                                @"type":@"2"
                                };
        NSDictionary *DEADic = @{
                                @"content" : [NSString stringWithFormat:@"DEA:%.2f", self.showMACDModel.DEA.floatValue],
                                @"color":[UIColor MTCurveOrangeColor],
                                @"type":@"2"
                                };
        NSDictionary *MACDDic = @{
                                @"content" : [NSString stringWithFormat:@"MACD:%.2f", self.showMACDModel.MACD.floatValue],
                                @"color":[UIColor MTCurveWhiteColor],
                                @"type":@"2"
                                };
        NSArray *contentAarray = [NSArray arrayWithObjects:DIFDic, DEADic, MACDDic, nil];
        [self.showDetailsView redrawWithArray:contentAarray];
    }
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    if (!self.needDrawMACDModels) {
        return;
    }
    
    if (![self lookupValueMaxAndValueMin]) {
        return;
    }
    
    self.unitValue = (self.currentValueMax - self.currentValueMin) / (self.currentValueMaxToViewY - self.currentValueMinToViewY);
    
    [self.MACDPositionModels removeAllObjects];
    [self.DIFPositionModels removeAllObjects];
    [self.DEAPositionModels removeAllObjects];
    
    self.zeroPointY = (self.currentValueMaxToViewY - self.currentValueMinToViewY) / 2;
    [self.needDrawMACDModels enumerateObjectsUsingBlock:^(MTCurveMACD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.unitValue <= 0.0000001) {
            *stop = YES;
        }
        
        MTCurveMACD *MACDModel = (MTCurveMACD *)obj;
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGFloat MIF_ScreenY = self.currentValueMaxToViewY;
        CGFloat MEA_ScreenY = self.currentValueMaxToViewY;
        CGFloat MACD_ScreenY = self.currentValueMaxToViewY;
        
        if (MACDModel.DIF.floatValue != MTCurveChartFloatMax) {
            MIF_ScreenY = self.currentValueMaxToViewY - (MACDModel.DIF.floatValue - self.currentValueMin)/self.unitValue;
        }
        if (MACDModel.DEA.floatValue != MTCurveChartFloatMax) {
            MEA_ScreenY = self.currentValueMaxToViewY - (MACDModel.DEA.floatValue - self.currentValueMin)/self.unitValue;
        }
        if (MACDModel.MACD.floatValue != MTCurveChartFloatMax) {
            MACD_ScreenY = self.currentValueMaxToViewY - (MACDModel.MACD.floatValue - self.currentValueMin)/self.unitValue;
        }
        
        NSAssert(!isnan(MIF_ScreenY) && !isnan(MEA_ScreenY) && !isnan(MACD_ScreenY), @"出现NAN值");
        CGPoint MACD_DIFScreenPoint = CGPointMake(ponitScreenX, MIF_ScreenY);
        CGPoint MACD_DEAScreenPoint = CGPointMake(ponitScreenX, MEA_ScreenY);
        CGPoint MACDScreenPoint = CGPointMake(ponitScreenX, MACD_ScreenY);
        
        [self.DIFPositionModels addObject: [NSValue valueWithCGPoint: MACD_DIFScreenPoint]];
        [self.DEAPositionModels addObject: [NSValue valueWithCGPoint: MACD_DEAScreenPoint]];
        [self.MACDPositionModels addObject: [NSValue valueWithCGPoint: MACDScreenPoint]];
    }];
    
}

- (BOOL)lookupValueMaxAndValueMin {
    if (self.needDrawMACDModels.count <= 0) {
        return NO;
    }
    
    __block CGFloat maxValue = MTCurveChartFloatMin;
    __block CGFloat minValue = MTCurveChartFloatMax;
    [self.needDrawMACDModels enumerateObjectsUsingBlock:^(MTCurveMACD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTCurveMACD *MACDModel = (MTCurveMACD *)obj;
        if (MACDModel.DIF.floatValue != MTCurveChartFloatMax) {
            if (MACDModel.DIF.floatValue > maxValue) {
                maxValue = MACDModel.DIF.floatValue;
            }
            if (MACDModel.DIF.floatValue < minValue) {
                minValue = MACDModel.DIF.floatValue;
            }
        }
        if (MACDModel.DEA.floatValue != MTCurveChartFloatMax) {
            if (MACDModel.DEA.floatValue > maxValue) {
                maxValue = MACDModel.DEA.floatValue;
            }
            if (MACDModel.DEA.floatValue < minValue) {
                minValue = MACDModel.DEA.floatValue;
            }
        }
        if (MACDModel.MACD.floatValue != MTCurveChartFloatMax) {
            if (MACDModel.MACD.floatValue > maxValue) {
                maxValue = MACDModel.MACD.floatValue;
            }
            if (MACDModel.MACD.floatValue < minValue) {
                minValue = MACDModel.MACD.floatValue;
            }
        }
    }];
    if (ABS(maxValue) > ABS(minValue)) {
        self.currentValueMax = ABS(maxValue);
        self.currentValueMin = -ABS(maxValue);
    } else {
        self.currentValueMax = ABS(minValue);
        self.currentValueMin = -ABS(minValue);
    }
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
