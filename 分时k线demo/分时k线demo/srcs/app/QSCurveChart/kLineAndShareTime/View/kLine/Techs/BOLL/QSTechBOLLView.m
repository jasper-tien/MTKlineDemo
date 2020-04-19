//
//  QSTechBOLLView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechBOLLView.h"
#import "QSCurveBOLL.h"
#import "QSKlineModel.h"
#import "QSCurveChartGlobalVariable.h"
#import "QSPointPositionKLineModel.h"
#import "QSMALine.h"
#import "UIColor+CurveChart.h"
#import "QSBOLLUSALine.h"
#import "QSShowDetailsView.h"

@interface QSTechBOLLView()

@property (nonatomic, strong) QSShowDetailsView *showDetailsView;
//中轨线
@property (nonatomic, strong) NSMutableArray *MBPositionModels;
//上轨线
@property (nonatomic, strong) NSMutableArray *UPPositionModels;
//下轨线
@property (nonatomic, strong) NSMutableArray *DNPositionModels;
//美国线
@property (nonatomic, strong) NSMutableArray *USAPositionModels;
@end

@implementation QSTechBOLLView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.UPPositionModels = @[].mutableCopy;
        self.MBPositionModels = @[].mutableCopy;
        self.DNPositionModels = @[].mutableCopy;
        self.USAPositionModels = @[].mutableCopy;
        self.backgroundColor = [UIColor backgroundColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawGrid:context];
    
    [self drawTopdeTailsView];
    
    [self drawBOLL:context];
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [QSCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawBOLL:(CGContextRef)context {
    QSMALine *MALine = [[QSMALine alloc] initWithContext:context];
    MALine.techType = QSCurveTechType_BOLL;
    if (self.UPPositionModels.count > 0) {
        MALine.MAType = MT_BOLL_UP;
        MALine.MAPositions = self.UPPositionModels;
        [MALine draw];
    }
    
    if (self.MBPositionModels.count > 0) {
        MALine.MAType = MT_BOLL_MB;
        MALine.MAPositions = self.MBPositionModels;
        [MALine draw];
    }
    
    if (self.DNPositionModels.count > 0) {
        MALine.MAType = MT_BOLL_DN;
        MALine.MAPositions = self.DNPositionModels;
        [MALine draw];
    }
    
    if (self.USAPositionModels.count > 0) {
        QSBOLLUSALine *bollUSALine = [[QSBOLLUSALine alloc] initWithContext:context];
        [self.USAPositionModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            bollUSALine.positionModel = obj;
            [bollUSALine draw];
        }];
    }
}

- (void)drawTopdeTailsView {
    NSString *titleStr = [NSString stringWithFormat:@"BOLL(20)"];
    NSDictionary *BOLLDic = @{
                          @"content" : titleStr,
                          @"color":[UIColor assistTextColor],
                          @"type":@"2"
                          };
    NSArray *contentAarray = [NSArray arrayWithObjects:BOLLDic, nil];
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
    } else if (index < self.needDrawBOLLModels.count && index > 0) {
        self.showBOLLModel = self.needDrawBOLLModels[index];
        NSDictionary *UPDic = @{
                              @"content" : [NSString stringWithFormat:@"UP:%.2f", self.showBOLLModel.BOLL_UP],
                              @"color":[UIColor MTCurveYellowColor],
                              @"type":@"2"
                              };
        NSDictionary *DNDic = @{
                                @"content" : [NSString stringWithFormat:@"DN:%.2f", self.showBOLLModel.BOLL_DN],
                                @"color":[UIColor MTCurveOrangeColor],
                                @"type":@"2"
                                };
        NSDictionary *MBDic = @{
                                @"content" : [NSString stringWithFormat:@"MB:%.2f", self.showBOLLModel.BOLL_MB],
                                @"color":[UIColor MTCurveWhiteColor],
                                @"type":@"2"
                                };
        NSArray *contentAarray = [NSArray arrayWithObjects:UPDic, DNDic, MBDic, nil];
        [self.showDetailsView redrawWithArray:contentAarray];
    }
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    if (![self lookupValueMaxAndValueMin]) {
        return;
    }
    
    self.unitValue = (self.currentValueMax - self.currentValueMin) / (self.currentValueMaxToViewY - self.currentValueMinToViewY);
    
    [self.UPPositionModels removeAllObjects];
    [self.DNPositionModels removeAllObjects];
    [self.MBPositionModels removeAllObjects];
    [self.USAPositionModels removeAllObjects];
    
    [self.needDrawBOLLModels enumerateObjectsUsingBlock:^(QSCurveBOLL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat ponitScreenX = idx * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
        QSCurveBOLL *bollModel = (QSCurveBOLL *)obj;
        CGFloat BOLL_UP_ScreenY = self.currentValueMaxToViewY;
        CGFloat BOLL_MB_ScreenY = self.currentValueMaxToViewY;
        CGFloat BOLL_DN_ScreenY = self.currentValueMaxToViewY;
        
        if(self.unitValue > 0.0000001)
        {
            if(bollModel.BOLL_UP)
            {
                BOLL_UP_ScreenY = self.currentValueMaxToViewY - (bollModel.BOLL_UP - self.currentValueMin)/self.unitValue;
            }
            if(bollModel.BOLL_MB)
            {
                BOLL_MB_ScreenY = self.currentValueMaxToViewY - (bollModel.BOLL_MB - self.currentValueMin)/self.unitValue;
            }
            if(bollModel.BOLL_DN)
            {
                BOLL_DN_ScreenY = self.currentValueMaxToViewY - (bollModel.BOLL_DN - self.currentValueMin)/self.unitValue;
            }
            
            NSAssert(!isnan(BOLL_UP_ScreenY) && !isnan(BOLL_MB_ScreenY) && !isnan(BOLL_DN_ScreenY), @"出现NAN值");
            CGPoint BOLL_UPScreenPoint = CGPointMake(ponitScreenX, BOLL_UP_ScreenY);
            CGPoint BOLL_MBScreenPoint = CGPointMake(ponitScreenX, BOLL_MB_ScreenY);
            CGPoint BOLL_DNScreenPoint = CGPointMake(ponitScreenX, BOLL_DN_ScreenY);
            if(bollModel.BOLL_UP)
            {
                [self.UPPositionModels addObject: [NSValue valueWithCGPoint: BOLL_UPScreenPoint]];
            }
            if(bollModel.BOLL_MB)
            {
                [self.MBPositionModels addObject: [NSValue valueWithCGPoint: BOLL_MBScreenPoint]];
            }
            if(bollModel.BOLL_DN)
            {
                [self.DNPositionModels addObject: [NSValue valueWithCGPoint: BOLL_DNScreenPoint]];
            }
        }
    }];
    
    [self.needDrawBOLLKlineModels enumerateObjectsUsingBlock:^(QSKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSKlineModel *kLineModel = (QSKlineModel *)obj;
        CGFloat ponitScreenX = idx * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
        CGPoint openScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.open - self.currentValueMin) / self.unitValue));
        CGPoint closeScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.close - self.currentValueMin) / self.unitValue));
        CGPoint highScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.high - self.currentValueMin) / self.unitValue));
        CGPoint lowScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.low - self.currentValueMin) / self.unitValue));
        QSPointPositionKLineModel *positionModel = [[QSPointPositionKLineModel alloc] init];
        positionModel.openPoint = openScreenPoint;
        positionModel.closePoint = closeScreenPoint;
        positionModel.highPoint = highScreenPoint;
        positionModel.lowPoint = lowScreenPoint;
        [self.USAPositionModels addObject:positionModel];
    }];
}

- (BOOL)lookupValueMaxAndValueMin {
    if (self.needDrawBOLLModels.count <= 0) {
        return NO;
    }
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    [self.needDrawBOLLModels enumerateObjectsUsingBlock:^(QSCurveBOLL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSCurveBOLL *bollModel = (QSCurveBOLL *)obj;
        if (bollModel.BOLL_UP) {
            if (bollModel.BOLL_UP > maxValue) {
                maxValue = bollModel.BOLL_UP;
            }
        }
        if (bollModel.BOLL_DN) {
            if (bollModel.BOLL_DN < minValue) {
                minValue = bollModel.BOLL_DN;
            }
        }
        if (idx < self.needDrawBOLLKlineModels.count) {
            QSKlineModel *kLineModel = self.needDrawBOLLKlineModels[idx];
            if (kLineModel.high > maxValue) {
                maxValue = kLineModel.high;
            }
            if (kLineModel.low < minValue) {
                minValue = kLineModel.low;
            }
        }
    }];
    
    self.currentValueMin = minValue;
    self.currentValueMax = maxValue;
    
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
