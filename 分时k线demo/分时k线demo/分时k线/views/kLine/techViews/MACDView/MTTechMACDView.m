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

@interface MTTechMACDView ()
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
    CGPoint drawTitlePoint = CGPointMake(5, 0);
    [titleStr drawAtPoint:drawTitlePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
}

#pragma mark -
- (void)drawTechView {
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
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
    
    CGFloat unitValue = maxValue_2 / maxY_2;
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
                MIF_Y = maxY_2 - MACDModel.DIF.floatValue/unitValue;
            } else {
                MIF_Y = 2 * maxY_2 - ABS(MACDModel.DIF.floatValue)/unitValue;
            }
        }
        if (MACDModel.DEA) {
            if (MACDModel.DEA.floatValue > 0) {
                MEA_Y = maxY_2 - MACDModel.DEA.floatValue/unitValue;
            } else {
                MEA_Y = 2 * maxY_2 - ABS(MACDModel.DEA.floatValue)/unitValue;
            }
        }
        if (MACDModel.MACD) {
            if (MACDModel.MACD.floatValue > 0) {
                MACD_Y = maxY_2 - MACDModel.MACD.floatValue/unitValue;
            } else {
                MACD_Y = 2 * maxY_2 - ABS(MACDModel.MACD.floatValue)/unitValue;
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

@end
