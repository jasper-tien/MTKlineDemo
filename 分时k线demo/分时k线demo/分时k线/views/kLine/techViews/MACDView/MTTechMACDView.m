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
#import "MTTechsShowView.h"

@interface MTTechMACDView ()
@property (nonatomic, strong) MTTechsShowView *MACDShowView;
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
    [self.MACDShowView redrawWithString:titleStr];
}

#pragma mark -
- (void)drawTechView {
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

- (void)redrawShowViewWithIndex:(NSInteger)index {
    if (index < self.needDrawMACDModels.count && index > 0) {
        self.showMACDModel = self.needDrawMACDModels[index];
        NSString *titleStr = [NSString stringWithFormat:@"DIF:%.2f DEA:%.2f MACD:%.2f", self.showMACDModel.DIF.floatValue, self.showMACDModel.DEA.floatValue, self.showMACDModel.MACD.floatValue];
        [self.MACDShowView redrawWithString:titleStr];
    }
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    CGFloat maxY_2 = MTCurveChartKLineAccessoryViewMaxY / 2;
    
    __block CGFloat maxValue_2 = CGFLOAT_MIN;
    [self.needDrawMACDModels enumerateObjectsUsingBlock:^(MTCurveMACD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTCurveMACD *MACDModel = (MTCurveMACD *)obj;
        if (MACDModel.DIF) {
            if (MACDModel.DIF.floatValue > maxValue_2) {
                maxValue_2 = MACDModel.DIF.floatValue;
            }
        }
        if (MACDModel.DEA) {
            if (MACDModel.DEA.floatValue > maxValue_2) {
                maxValue_2 = MACDModel.DEA.floatValue;
            }
        }
        if (MACDModel.MACD) {
            if (MACDModel.MACD.floatValue > maxValue_2) {
                maxValue_2 = MACDModel.MACD.floatValue;
            }
        }
    }];
    
    self.unitValue = maxValue_2 / maxY_2;
    [self.MACDPositionModels removeAllObjects];
    [self.DIFPositionModels removeAllObjects];
    [self.DEAPositionModels removeAllObjects];
    self.zeroPointY = maxY_2;
    [self.needDrawMACDModels enumerateObjectsUsingBlock:^(MTCurveMACD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTCurveMACD *MACDModel = (MTCurveMACD *)obj;
        CGFloat xPosition = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGFloat MIF_Y = maxY_2;
        CGFloat MEA_Y = maxY_2;
        CGFloat MACD_Y = maxY_2;
        
        if (MACDModel.DIF) {
            if (MACDModel.DIF.floatValue > 0) {
                MIF_Y = maxY_2 - MACDModel.DIF.floatValue/self.unitValue;
            } else {
                MIF_Y = 2 * maxY_2 - ABS(MACDModel.DIF.floatValue)/self.unitValue;
            }
        }
        if (MACDModel.DEA) {
            if (MACDModel.DEA.floatValue > 0) {
                MEA_Y = maxY_2 - MACDModel.DEA.floatValue/self.unitValue;
            } else {
                MEA_Y = 2 * maxY_2 - ABS(MACDModel.DEA.floatValue)/self.unitValue;
            }
        }
        if (MACDModel.MACD) {
            if (MACDModel.MACD.floatValue > 0) {
                MACD_Y = maxY_2 - MACDModel.MACD.floatValue/self.unitValue;
            } else {
                MACD_Y = 2 * maxY_2 - ABS(MACDModel.MACD.floatValue)/self.unitValue;
            }
        }
        
        NSAssert(!isnan(MIF_Y) && !isnan(MEA_Y) && !isnan(MACD_Y), @"出现NAN值");
        CGPoint MACD_DIFPoint = CGPointMake(xPosition, MIF_Y);
        CGPoint MACD_DEAPoint = CGPointMake(xPosition, MEA_Y);
        CGPoint MACDPoint = CGPointMake(xPosition, MACD_Y);
        if(MACDModel.DIF)
        {
            [self.DIFPositionModels addObject: [NSValue valueWithCGPoint: MACD_DIFPoint]];
        }
        if(MACDModel.DEA)
        {
            [self.DEAPositionModels addObject: [NSValue valueWithCGPoint: MACD_DEAPoint]];
        }
        if (MACDModel.MACD) {
            [self.MACDPositionModels addObject: [NSValue valueWithCGPoint: MACDPoint]];
        }
    }];
    
}

#pragma mark -
- (MTTechsShowView *)MACDShowView {
    if (!_MACDShowView) {
        _MACDShowView = [[MTTechsShowView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self addSubview:_MACDShowView];
    }
    
    return _MACDShowView;
}

@end
