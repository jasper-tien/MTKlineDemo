//
//  QSTechKDJView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechKDJView.h"
#import "QSCurveKDJ.h"
#import "QSConstant.h"
#import "QSCurveChartGlobalVariable.h"
#import "QSMALine.h"
#import "UIColor+CurveChart.h"
#import "QSShowDetailsView.h"

@interface QSTechKDJView ()
@property (nonatomic, strong) QSShowDetailsView *showDetailsView;
@property (nonatomic, strong) NSMutableArray *KPositionModels;
@property (nonatomic, strong) NSMutableArray *DPositionModels;
@property (nonatomic, strong) NSMutableArray *JPositionModels;
@end

@implementation QSTechKDJView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.KPositionModels = @[].mutableCopy;
        self.DPositionModels = @[].mutableCopy;
        self.JPositionModels = @[].mutableCopy;
        self.backgroundColor = [UIColor backgroundColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawGrid:context];
    
    [self drawTopdeTailsView];
    
    [self drawKDJ:context];
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [QSCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawKDJ:(CGContextRef)context {
    QSMALine *MALine = [[QSMALine alloc] initWithContext:context];
    MALine.techType = QSCurveTechType_KDJ;
    if (self.KPositionModels.count > 0) {
        MALine.MAType = MT_KDJ_K;
        MALine.MAPositions = self.KPositionModels;
        [MALine draw];
    }
    
    if (self.DPositionModels.count > 0) {
        MALine.MAType = MT_KDJ_D;
        MALine.MAPositions = self.DPositionModels;
        [MALine draw];
    }
    
    if (self.JPositionModels.count > 0) {
        MALine.MAType = MT_KDJ_J;
        MALine.MAPositions = self.JPositionModels;
        [MALine draw];
    }
}

- (void)drawTopdeTailsView {
    NSString *titleStr = [NSString stringWithFormat:@"KDJ(9, 3, 3)"];
    NSDictionary *KDJDic = @{
                              @"content" : titleStr,
                              @"color":[UIColor assistTextColor],
                              @"type":@"2"
                              };
    NSArray *contentAarray = [NSArray arrayWithObjects:KDJDic, nil];
    [self.showDetailsView redrawWithArray:contentAarray];
}

#pragma mark -
- (void)drawTechView {
    [super drawTechView];
    //重新绘制成交量的视图
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

- (void)reDrawShowViewWithIndex:(NSInteger)index {
    if (index == -1) {
        [self drawTopdeTailsView];
    } else if (index < self.needDrawKDJModels.count && index > 0) {
        self.showKDJModel = self.needDrawKDJModels[index];
        NSDictionary *KDic = @{
                                @"content" : [NSString stringWithFormat:@"K:%.2f", self.showKDJModel.KDJ_K],
                                @"color":[UIColor mainTextColor],
                                @"type":@"2"
                                };
        NSDictionary *DDic = @{
                                @"content" : [NSString stringWithFormat:@"D:%.2f", self.showKDJModel.KDJ_D],
                                @"color":[UIColor MTCurveYellowColor],
                                @"type":@"2"
                                };
        NSDictionary *JDic = @{
                                @"content" : [NSString stringWithFormat:@"J:%.2f", self.showKDJModel.KDJ_J],
                                @"color":[UIColor MTCurveVioletColor],
                                @"type":@"2"
                                };
        NSArray *contentAarray = [NSArray arrayWithObjects:KDic, DDic, JDic, nil];
        [self.showDetailsView redrawWithArray:contentAarray];
    }
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    if (![self lookupValueMaxAndValueMin]) {
        return;
    }
    
   self.unitValue = (self.currentValueMax - self.currentValueMin) / (self.currentValueMaxToViewY - self.currentValueMinToViewY);
    
    [self.KPositionModels removeAllObjects];
    [self.DPositionModels removeAllObjects];
    [self.JPositionModels removeAllObjects];
    
    [self.needDrawKDJModels enumerateObjectsUsingBlock:^(QSCurveKDJ * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    CGFloat ponitScreenX = idx * ([QSCurveChartGlobalVariable kLineWidth] + [QSCurveChartGlobalVariable kLineGap]);
        QSCurveKDJ *model = (QSCurveKDJ *)obj;
        //MA坐标转换
        CGFloat KDJ_K_ScreenY = self.currentValueMaxToViewY;
        CGFloat KDJ_D_ScreenY = self.currentValueMaxToViewY;
        CGFloat KDJ_J_ScreenY = self.currentValueMaxToViewY;
        if(self.unitValue > 0.0000001)
        {
            if(model.KDJ_K)
            {
                KDJ_K_ScreenY = self.currentValueMaxToViewY - (model.KDJ_K - self.currentValueMin)/self.unitValue;
            }
            
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.KDJ_D)
            {
                KDJ_D_ScreenY = self.currentValueMaxToViewY - (model.KDJ_D - self.currentValueMin)/self.unitValue;
            }
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.KDJ_J)
            {
                KDJ_J_ScreenY = self.currentValueMaxToViewY - (model.KDJ_J - self.currentValueMin)/self.unitValue;
            }
        }
        
        NSAssert(!isnan(KDJ_K_ScreenY) && !isnan(KDJ_D_ScreenY) && !isnan(KDJ_J_ScreenY), @"出现NAN值");
        
        CGPoint KDJ_KScreenPoint = CGPointMake(ponitScreenX, KDJ_K_ScreenY);
        CGPoint KDJ_DScreenPoint = CGPointMake(ponitScreenX, KDJ_D_ScreenY);
        CGPoint KDJ_JScreenPoint = CGPointMake(ponitScreenX, KDJ_J_ScreenY);
        
        
        if(model.KDJ_K)
        {
            [self.KPositionModels addObject: [NSValue valueWithCGPoint: KDJ_KScreenPoint]];
        }
        if(model.KDJ_D)
        {
            [self.DPositionModels addObject: [NSValue valueWithCGPoint: KDJ_DScreenPoint]];
        }
        if(model.KDJ_J)
        {
            [self.JPositionModels addObject: [NSValue valueWithCGPoint: KDJ_JScreenPoint]];
        }
    }];
}

- (BOOL)lookupValueMaxAndValueMin {
    if (self.needDrawKDJModels.count <= 0) {
        return NO;
    }
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    [self.needDrawKDJModels enumerateObjectsUsingBlock:^(QSCurveKDJ * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSCurveKDJ *KDJModel = (QSCurveKDJ *)obj;
        if(KDJModel.KDJ_K)
        {
            if (minValue > KDJModel.KDJ_K) {
                minValue = KDJModel.KDJ_K;
            }
            if (maxValue < KDJModel.KDJ_K) {
                maxValue = KDJModel.KDJ_K;
            }
        }
        
        if(KDJModel.KDJ_D)
        {
            if (minValue > KDJModel.KDJ_D) {
                minValue = KDJModel.KDJ_D;
            }
            if (maxValue < KDJModel.KDJ_D) {
                maxValue = KDJModel.KDJ_D;
            }
        }
        if(KDJModel.KDJ_J)
        {
            if (minValue > KDJModel.KDJ_J) {
                minValue = KDJModel.KDJ_J;
            }
            if (maxValue < KDJModel.KDJ_J) {
                maxValue = KDJModel.KDJ_J;
            }
        }
    }];
    self.currentValueMax = maxValue;
    self.currentValueMin = minValue;
    
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
