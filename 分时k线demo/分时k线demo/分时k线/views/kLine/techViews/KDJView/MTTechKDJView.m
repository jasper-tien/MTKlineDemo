//
//  MTTechKDJView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechKDJView.h"
#import "MTCurveKDJ.h"
#import "SJCurveChartConstant.h"
#import "MTCurveChartGlobalVariable.h"
#import "MTMALine.h"
#import "UIColor+CurveChart.h"
#import "MTShowDetailsView.h"

@interface MTTechKDJView ()
@property (nonatomic, strong) MTShowDetailsView *showDetailsView;
@property (nonatomic, strong) NSMutableArray *KPositionModels;
@property (nonatomic, strong) NSMutableArray *DPositionModels;
@property (nonatomic, strong) NSMutableArray *JPositionModels;
@end

@implementation MTTechKDJView
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
    CGFloat gridLineWidth = [MTCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawKDJ:(CGContextRef)context {
    MTMALine *MALine = [[MTMALine alloc] initWithContext:context];
    MALine.techType = SJCurveTechType_KDJ;
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
        CGFloat KValue = self.showKDJModel.KDJ_K.floatValue;
        if (KValue == MTCurveChartFloatMax) {
            KValue = 0.0f;
        }
        CGFloat DValue = self.showKDJModel.KDJ_D.floatValue;
        if (DValue == MTCurveChartFloatMax) {
            DValue = 0.0f;
        }
        CGFloat JValue = self.showKDJModel.KDJ_J.floatValue;
        if (JValue == MTCurveChartFloatMax) {
            JValue = 0.0f;
        }
        NSDictionary *KDic = @{
                                @"content" : [NSString stringWithFormat:@"K:%.2f", KValue],
                                @"color":[UIColor mainTextColor],
                                @"type":@"2"
                                };
        NSDictionary *DDic = @{
                                @"content" : [NSString stringWithFormat:@"D:%.2f", DValue],
                                @"color":[UIColor MTCurveYellowColor],
                                @"type":@"2"
                                };
        NSDictionary *JDic = @{
                                @"content" : [NSString stringWithFormat:@"J:%.2f", JValue],
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
    
    [self.needDrawKDJModels enumerateObjectsUsingBlock:^(MTCurveKDJ * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.unitValue <= 0.0000001) {
            *stop = YES;
        }
        
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        MTCurveKDJ *model = (MTCurveKDJ *)obj;
        //MA坐标转换
        CGFloat KDJ_K_ScreenY = self.currentValueMaxToViewY;
        CGFloat KDJ_D_ScreenY = self.currentValueMaxToViewY;
        CGFloat KDJ_J_ScreenY = self.currentValueMaxToViewY;
        
        if(model.KDJ_K.floatValue != MTCurveChartFloatMax)
        {
            KDJ_K_ScreenY = self.currentValueMaxToViewY - (model.KDJ_K.floatValue - self.currentValueMin)/self.unitValue;
        }
        if(model.KDJ_D.floatValue != MTCurveChartFloatMax)
        {
            KDJ_D_ScreenY = self.currentValueMaxToViewY - (model.KDJ_D.floatValue - self.currentValueMin)/self.unitValue;
        }
        if(model.KDJ_J.floatValue != MTCurveChartFloatMax)
        {
            KDJ_J_ScreenY = self.currentValueMaxToViewY - (model.KDJ_J.floatValue - self.currentValueMin)/self.unitValue;
        }
        
        NSAssert(!isnan(KDJ_K_ScreenY) && !isnan(KDJ_D_ScreenY) && !isnan(KDJ_J_ScreenY), @"出现NAN值");
        
        CGPoint KDJ_KScreenPoint = CGPointMake(ponitScreenX, KDJ_K_ScreenY);
        CGPoint KDJ_DScreenPoint = CGPointMake(ponitScreenX, KDJ_D_ScreenY);
        CGPoint KDJ_JScreenPoint = CGPointMake(ponitScreenX, KDJ_J_ScreenY);
        
        [self.KPositionModels addObject: [NSValue valueWithCGPoint: KDJ_KScreenPoint]];
        [self.DPositionModels addObject: [NSValue valueWithCGPoint: KDJ_DScreenPoint]];
        [self.JPositionModels addObject: [NSValue valueWithCGPoint: KDJ_JScreenPoint]];
    }];
}

- (BOOL)lookupValueMaxAndValueMin {
    if (self.needDrawKDJModels.count <= 0) {
        return NO;
    }
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    [self.needDrawKDJModels enumerateObjectsUsingBlock:^(MTCurveKDJ * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTCurveKDJ *KDJModel = (MTCurveKDJ *)obj;
        if(KDJModel.KDJ_K.floatValue != MTCurveChartFloatMax)
        {
            if (minValue > KDJModel.KDJ_K.floatValue) {
                minValue = KDJModel.KDJ_K.floatValue;
            }
            if (maxValue < KDJModel.KDJ_K.floatValue) {
                maxValue = KDJModel.KDJ_K.floatValue;
            }
        }
        
        if(KDJModel.KDJ_D.floatValue != MTCurveChartFloatMax)
        {
            if (minValue > KDJModel.KDJ_D.floatValue) {
                minValue = KDJModel.KDJ_D.floatValue;
            }
            if (maxValue < KDJModel.KDJ_D.floatValue) {
                maxValue = KDJModel.KDJ_D.floatValue;
            }
        }
        if(KDJModel.KDJ_J.floatValue != MTCurveChartFloatMax)
        {
            if (minValue > KDJModel.KDJ_J.floatValue) {
                minValue = KDJModel.KDJ_J.floatValue;
            }
            if (maxValue < KDJModel.KDJ_J.floatValue) {
                maxValue = KDJModel.KDJ_J.floatValue;
            }
        }
    }];
    self.currentValueMax = maxValue;
    self.currentValueMin = minValue;
    
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
