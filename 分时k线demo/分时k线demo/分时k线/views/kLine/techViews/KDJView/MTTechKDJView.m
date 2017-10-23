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
#import "MTTechsShowView.h"

@interface MTTechKDJView ()
@property (nonatomic, strong) MTTechsShowView *KDJShowView;
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
    [self.KDJShowView redrawWithString:titleStr];
}

#pragma mark -
- (void)drawTechView {
    [super drawTechView];
    //重新绘制成交量的视图
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

- (void)reDrawShowViewWithIndex:(NSInteger)index {
    if (index < self.needDrawKDJModels.count && index > 0) {
        self.showKDJModel = self.needDrawKDJModels[index];
        NSString *titleStr = [NSString stringWithFormat:@"K:%.2f D:%.2f J:%.2f", self.showKDJModel.KDJ_K.floatValue, self.showKDJModel.KDJ_D.floatValue, self.showKDJModel.KDJ_J.floatValue];
        [self.KDJShowView redrawWithString:titleStr];
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
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        MTCurveKDJ *model = (MTCurveKDJ *)obj;
        //MA坐标转换
        CGFloat KDJ_K_ScreenY = self.currentValueMaxToViewY;
        CGFloat KDJ_D_ScreenY = self.currentValueMaxToViewY;
        CGFloat KDJ_J_ScreenY = self.currentValueMaxToViewY;
        if(self.unitValue > 0.0000001)
        {
            if(model.KDJ_K)
            {
                KDJ_K_ScreenY = self.currentValueMaxToViewY - (model.KDJ_K.floatValue - self.currentValueMin)/self.unitValue;
            }
            
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.KDJ_D)
            {
                KDJ_D_ScreenY = self.currentValueMaxToViewY - (model.KDJ_D.floatValue - self.currentValueMin)/self.unitValue;
            }
        }
        if(self.unitValue > 0.0000001)
        {
            if(model.KDJ_J)
            {
                KDJ_J_ScreenY = self.currentValueMaxToViewY - (model.KDJ_J.floatValue - self.currentValueMin)/self.unitValue;
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
    [self.needDrawKDJModels enumerateObjectsUsingBlock:^(MTCurveKDJ * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTCurveKDJ *KDJModel = (MTCurveKDJ *)obj;
        if(KDJModel.KDJ_K)
        {
            if (minValue > KDJModel.KDJ_K.floatValue) {
                minValue = KDJModel.KDJ_K.floatValue;
            }
            if (maxValue < KDJModel.KDJ_K.floatValue) {
                maxValue = KDJModel.KDJ_K.floatValue;
            }
        }
        
        if(KDJModel.KDJ_D)
        {
            if (minValue > KDJModel.KDJ_D.floatValue) {
                minValue = KDJModel.KDJ_D.floatValue;
            }
            if (maxValue < KDJModel.KDJ_D.floatValue) {
                maxValue = KDJModel.KDJ_D.floatValue;
            }
        }
        if(KDJModel.KDJ_J)
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
- (MTTechsShowView *)KDJShowView {
    if (!_KDJShowView) {
        _KDJShowView = [[MTTechsShowView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self addSubview:_KDJShowView];
    }
    
    return _KDJShowView;
}

@end
