//
//  QSTechMACDView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechMACDView.h"
#import "QSCurveMACD.h"
#import "UIColor+CurveChart.h"
#import "QSConstant.h"
#import "QSCurveChartGlobalVariable.h"
#import "QSMACDLine.h"
#import "QSMALine.h"
#import "QSShowDetailsView.h"

@interface QSTechMACDView ()
@property (nonatomic, strong) QSShowDetailsView *showDetailsView;
@property (nonatomic, strong) NSMutableArray *DIFPositionModels;
@property (nonatomic, strong) NSMutableArray *DEAPositionModels;
@property (nonatomic, strong) NSMutableArray *MACDPositionModels;
@property (nonatomic, assign) CGFloat zeroPointY;
@end

@implementation QSTechMACDView
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
    CGFloat gridLineWidth = [QSCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawMACD:(CGContextRef)context {
    QSMALine *MALine = [[QSMALine alloc] initWithContext:context];
    MALine.techType = QSCurveTechType_MACD;
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
        QSMACDLine *MACDKline = [[QSMACDLine alloc] initWithContext:context];
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
                                @"content" : [NSString stringWithFormat:@"DIF:%.2f", self.showMACDModel.DIF],
                                @"color":[UIColor MTCurveYellowColor],
                                @"type":@"2"
                                };
        NSDictionary *DEADic = @{
                                @"content" : [NSString stringWithFormat:@"DEA:%.2f", self.showMACDModel.DEA],
                                @"color":[UIColor MTCurveOrangeColor],
                                @"type":@"2"
                                };
        NSDictionary *MACDDic = @{
                                @"content" : [NSString stringWithFormat:@"MACD:%.2f", self.showMACDModel.MACD],
                                @"color":[UIColor MTCurveWhiteColor],
                                @"type":@"2"
                                };
        NSArray *contentAarray = [NSArray arrayWithObjects:DIFDic, DEADic, MACDDic, nil];
        [self.showDetailsView redrawWithArray:contentAarray];
    }
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    if (![self lookupValueMaxAndValueMin]) {
        return;
    }
    
    self.unitValue = (self.currentValueMax - self.currentValueMin) / (self.currentValueMaxToViewY - self.currentValueMinToViewY);
    
    [self.MACDPositionModels removeAllObjects];
    [self.DIFPositionModels removeAllObjects];
    [self.DEAPositionModels removeAllObjects];
    
    self.zeroPointY = (self.currentValueMaxToViewY - self.currentValueMinToViewY) / 2;
    [self.needDrawMACDModels enumerateObjectsUsingBlock:^(QSCurveMACD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSCurveMACD *MACDModel = (QSCurveMACD *)obj;
        CGFloat ponitScreenX = idx * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
        CGFloat MIF_ScreenY = self.currentValueMaxToViewY;
        CGFloat MEA_ScreenY = self.currentValueMaxToViewY;
        CGFloat MACD_ScreenY = self.currentValueMaxToViewY;
        
        if (MACDModel.DIF) {
            MIF_ScreenY = self.currentValueMaxToViewY - (MACDModel.DIF - self.currentValueMin)/self.unitValue;
        }
        if (MACDModel.DEA) {
            MEA_ScreenY = self.currentValueMaxToViewY - (MACDModel.DEA - self.currentValueMin)/self.unitValue;
        }
        if (MACDModel.MACD) {
            MACD_ScreenY = self.currentValueMaxToViewY - (MACDModel.MACD - self.currentValueMin)/self.unitValue;
        }
        
        NSAssert(!isnan(MIF_ScreenY) && !isnan(MEA_ScreenY) && !isnan(MACD_ScreenY), @"出现NAN值");
        CGPoint MACD_DIFScreenPoint = CGPointMake(ponitScreenX, MIF_ScreenY);
        CGPoint MACD_DEAScreenPoint = CGPointMake(ponitScreenX, MEA_ScreenY);
        CGPoint MACDScreenPoint = CGPointMake(ponitScreenX, MACD_ScreenY);
        if(MACDModel.DIF)
        {
            [self.DIFPositionModels addObject: [NSValue valueWithCGPoint: MACD_DIFScreenPoint]];
        }
        if(MACDModel.DEA)
        {
            [self.DEAPositionModels addObject: [NSValue valueWithCGPoint: MACD_DEAScreenPoint]];
        }
        if (MACDModel.MACD) {
            [self.MACDPositionModels addObject: [NSValue valueWithCGPoint: MACDScreenPoint]];
        }
    }];
    
}

- (BOOL)lookupValueMaxAndValueMin {
    __block CGFloat maxValue = CGFLOAT_MIN;
    __block CGFloat minValue = CGFLOAT_MAX;
    [self.needDrawMACDModels enumerateObjectsUsingBlock:^(QSCurveMACD * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSCurveMACD *MACDModel = (QSCurveMACD *)obj;
        if (MACDModel.DIF) {
            if (MACDModel.DIF > maxValue) {
                maxValue = MACDModel.DIF;
            }
            if (MACDModel.DIF < minValue) {
                minValue = MACDModel.DIF;
            }
        }
        if (MACDModel.DEA) {
            if (MACDModel.DEA > maxValue) {
                maxValue = MACDModel.DEA;
            }
            if (MACDModel.DEA < minValue) {
                minValue = MACDModel.DEA;
            }
        }
        if (MACDModel.MACD) {
            if (MACDModel.MACD > maxValue) {
                maxValue = MACDModel.MACD;
            }
            if (MACDModel.MACD < minValue) {
                minValue = MACDModel.MACD;
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
- (QSShowDetailsView *)showDetailsView {
    if (!_showDetailsView) {
    _showDetailsView = [[QSShowDetailsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        [self addSubview:_showDetailsView];
    }
    
    return _showDetailsView;
}

@end
