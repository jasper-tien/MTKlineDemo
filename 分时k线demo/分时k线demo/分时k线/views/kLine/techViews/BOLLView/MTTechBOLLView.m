//
//  MTTechBOLLView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/12.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechBOLLView.h"
#import "MTCurveBOLL.h"
#import "SJKlineModel.h"
#import "MTCurveChartGlobalVariable.h"
#import "MTKLinePositionModel.h"
#import "MTMALine.h"
#import "UIColor+CurveChart.h"
#import "MTBOLLUSALine.h"

@interface MTTechBOLLView ()
//中轨线
@property (nonatomic, strong) NSMutableArray *MBPositionModels;
//上轨线
@property (nonatomic, strong) NSMutableArray *UPPositionModels;
//下轨线
@property (nonatomic, strong) NSMutableArray *DNPositionModels;
//美国线
@property (nonatomic, strong) NSMutableArray *USAPositionModels;
@end

@implementation MTTechBOLLView
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
    MTMALine *MALine = [[MTMALine alloc] initWithContext:context];
    MALine.techType = SJCurveTechType_BOLL;
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
        MTBOLLUSALine *bollUSALine = [[MTBOLLUSALine alloc] initWithContext:context];
        [self.USAPositionModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            bollUSALine.positionModel = obj;
            [bollUSALine draw];
        }];
    }
}

- (void)drawTechView {
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

#pragma mark -
- (void)convertToVolumePositionModelWithKLineModels {
    CGFloat minY = MTCurveChartKLineAccessoryViewMinY;
    CGFloat maxY = MTCurveChartKLineAccessoryViewMaxY;
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    [self.needDrawBOLLModels enumerateObjectsUsingBlock:^(MTCurveBOLL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTCurveBOLL *bollModel = (MTCurveBOLL *)obj;
        if (bollModel.BOLL_UP) {
            if (bollModel.BOLL_UP.floatValue > maxValue) {
                maxValue = bollModel.BOLL_UP.floatValue;
            }
        }
        if (bollModel.BOLL_DN) {
            if (bollModel.BOLL_DN.floatValue < minValue) {
                minValue = bollModel.BOLL_DN.floatValue;
            }
        }
        if (idx < self.needDrawBOLLKlineModels.count) {
            SJKlineModel *kLineModel = self.needDrawBOLLKlineModels[idx];
            if (kLineModel.high.floatValue > maxValue) {
                maxValue = kLineModel.high.floatValue;
            }
            if (kLineModel.low.floatValue < minValue) {
                minValue = kLineModel.low.floatValue;
            }
        }
    }];
    
     CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
    [self.UPPositionModels removeAllObjects];
    [self.DNPositionModels removeAllObjects];
    [self.MBPositionModels removeAllObjects];
    [self.USAPositionModels removeAllObjects];
    
    [self.needDrawBOLLModels enumerateObjectsUsingBlock:^(MTCurveBOLL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat xPosition = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        MTCurveBOLL *bollModel = (MTCurveBOLL *)obj;
        CGFloat BOLL_UP_Y = maxY;
        CGFloat BOLL_MB_Y = maxY;
        CGFloat BOLL_DN_Y = maxY;
        
        if(unitValue > 0.0000001)
        {
            if(bollModel.BOLL_UP)
            {
                BOLL_UP_Y = maxY - (bollModel.BOLL_UP.floatValue - minValue)/unitValue;
            }
            if(bollModel.BOLL_MB)
            {
                BOLL_MB_Y = maxY - (bollModel.BOLL_MB.floatValue - minValue)/unitValue;
            }
            if(bollModel.BOLL_DN)
            {
                BOLL_DN_Y = maxY - (bollModel.BOLL_DN.floatValue - minValue)/unitValue;
            }
            
            NSAssert(!isnan(BOLL_UP_Y) && !isnan(BOLL_MB_Y) && !isnan(BOLL_DN_Y), @"出现NAN值");
            CGPoint BOLL_UPPoint = CGPointMake(xPosition, BOLL_UP_Y);
            CGPoint BOLL_MBPoint = CGPointMake(xPosition, BOLL_MB_Y);
            CGPoint BOLL_DNPoint = CGPointMake(xPosition, BOLL_DN_Y);
            if(bollModel.BOLL_UP)
            {
                [self.UPPositionModels addObject: [NSValue valueWithCGPoint: BOLL_UPPoint]];
            }
            if(bollModel.BOLL_MB)
            {
                [self.MBPositionModels addObject: [NSValue valueWithCGPoint: BOLL_MBPoint]];
            }
            if(bollModel.BOLL_DN)
            {
                [self.DNPositionModels addObject: [NSValue valueWithCGPoint: BOLL_DNPoint]];
            }
        }
    }];
    
    [self.needDrawBOLLKlineModels enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SJKlineModel *kLineModel = (SJKlineModel *)obj;
        CGFloat ponitX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGPoint openPoint = CGPointMake(ponitX, ABS(maxY - (kLineModel.open.floatValue - minValue) / unitValue));
        CGPoint closePoint = CGPointMake(ponitX, ABS(maxY - (kLineModel.close.floatValue - minValue) / unitValue));
        CGPoint highPoint = CGPointMake(ponitX, ABS(maxY - (kLineModel.high.floatValue - minValue) / unitValue));
        CGPoint lowPoint = CGPointMake(ponitX, ABS(maxY - (kLineModel.low.floatValue - minValue) / unitValue));
        MTKLinePositionModel *positionModel = [[MTKLinePositionModel alloc] init];
        positionModel.openPoint = openPoint;
        positionModel.closePoint = closePoint;
        positionModel.highPoint = highPoint;
        positionModel.lowPoint = lowPoint;
        [self.USAPositionModels addObject:positionModel];
    }];
}

@end
