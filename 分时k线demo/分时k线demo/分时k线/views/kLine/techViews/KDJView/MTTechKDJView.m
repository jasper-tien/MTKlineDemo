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

@interface MTTechKDJView ()
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

- (void)drawTechView {
    [super drawTechView];
    //重新绘制成交量的视图
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    CGFloat minY = MTCurveChartKLineAccessoryViewMinY;
    CGFloat maxY = MTCurveChartKLineAccessoryViewMaxY;
    
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
    
    CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
    
    [self.KPositionModels removeAllObjects];
    [self.DPositionModels removeAllObjects];
    [self.JPositionModels removeAllObjects];
    
    [self.needDrawKDJModels enumerateObjectsUsingBlock:^(MTCurveKDJ * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat xPosition = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        MTCurveKDJ *model = (MTCurveKDJ *)obj;
        //MA坐标转换
        CGFloat KDJ_K_Y = maxY;
        CGFloat KDJ_D_Y = maxY;
        CGFloat KDJ_J_Y = maxY;
        if(unitValue > 0.0000001)
        {
            if(model.KDJ_K)
            {
                KDJ_K_Y = maxY - (model.KDJ_K.floatValue - minValue)/unitValue;
            }
            
        }
        if(unitValue > 0.0000001)
        {
            if(model.KDJ_D)
            {
                KDJ_D_Y = maxY - (model.KDJ_D.floatValue - minValue)/unitValue;
            }
        }
        if(unitValue > 0.0000001)
        {
            if(model.KDJ_J)
            {
                KDJ_J_Y = maxY - (model.KDJ_J.floatValue - minValue)/unitValue;
            }
        }
        
        NSAssert(!isnan(KDJ_K_Y) && !isnan(KDJ_D_Y) && !isnan(KDJ_J_Y), @"出现NAN值");
        
        CGPoint KDJ_KPoint = CGPointMake(xPosition, KDJ_K_Y);
        CGPoint KDJ_DPoint = CGPointMake(xPosition, KDJ_D_Y);
        CGPoint KDJ_JPoint = CGPointMake(xPosition, KDJ_J_Y);
        
        
        if(model.KDJ_K)
        {
            [self.KPositionModels addObject: [NSValue valueWithCGPoint: KDJ_KPoint]];
        }
        if(model.KDJ_D)
        {
            [self.DPositionModels addObject: [NSValue valueWithCGPoint: KDJ_DPoint]];
        }
        if(model.KDJ_J)
        {
            [self.JPositionModels addObject: [NSValue valueWithCGPoint: KDJ_JPoint]];
        }
    }];
}

@end
