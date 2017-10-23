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
#import "MTTechsShowView.h"

@interface MTTechBOLLView ()
@property (nonatomic, strong) MTTechsShowView *BOLLShowView;
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
    
    [self drawGrid:context];
    
    [self drawTopdeTailsView];
    
    [self drawBOLL:context];
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [MTCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2 * gridLineWidth));
    CGContextStrokePath(context);
}

- (void)drawBOLL:(CGContextRef)context {
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

- (void)drawTopdeTailsView {
    NSString *titleStr = [NSString stringWithFormat:@"BOLL(20)"];
    [self.BOLLShowView redrawWithString:titleStr];
}

#pragma mark -
- (void)drawTechView {
    [self convertToVolumePositionModelWithKLineModels];
    [self setNeedsDisplay];
}

- (void)redrawShowViewWithIndex:(NSInteger)index {
    if (index < self.needDrawBOLLModels.count && index > 0) {
        self.showBOLLModel = self.needDrawBOLLModels[index];
        NSString *titleStr = [NSString stringWithFormat:@"UP:%.2f MB:%.2f DN:%.2f", self.showBOLLModel.BOLL_UP.floatValue, self.showBOLLModel.BOLL_MB.floatValue, self.showBOLLModel.BOLL_DN.floatValue];
        [self.BOLLShowView redrawWithString:titleStr];
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
    
    [self.needDrawBOLLModels enumerateObjectsUsingBlock:^(MTCurveBOLL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        MTCurveBOLL *bollModel = (MTCurveBOLL *)obj;
        CGFloat BOLL_UP_ScreenY = self.currentValueMaxToViewY;
        CGFloat BOLL_MB_ScreenY = self.currentValueMaxToViewY;
        CGFloat BOLL_DN_ScreenY = self.currentValueMaxToViewY;
        
        if(self.unitValue > 0.0000001)
        {
            if(bollModel.BOLL_UP)
            {
                BOLL_UP_ScreenY = self.currentValueMaxToViewY - (bollModel.BOLL_UP.floatValue - self.currentValueMin)/self.unitValue;
            }
            if(bollModel.BOLL_MB)
            {
                BOLL_MB_ScreenY = self.currentValueMaxToViewY - (bollModel.BOLL_MB.floatValue - self.currentValueMin)/self.unitValue;
            }
            if(bollModel.BOLL_DN)
            {
                BOLL_DN_ScreenY = self.currentValueMaxToViewY - (bollModel.BOLL_DN.floatValue - self.currentValueMin)/self.unitValue;
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
    
    [self.needDrawBOLLKlineModels enumerateObjectsUsingBlock:^(SJKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SJKlineModel *kLineModel = (SJKlineModel *)obj;
        CGFloat ponitScreenX = idx * ([MTCurveChartGlobalVariable kLineWidth] + [MTCurveChartGlobalVariable kLineGap]);
        CGPoint openScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.open.floatValue - self.currentValueMin) / self.unitValue));
        CGPoint closeScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.close.floatValue - self.currentValueMin) / self.unitValue));
        CGPoint highScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.high.floatValue - self.currentValueMin) / self.unitValue));
        CGPoint lowScreenPoint = CGPointMake(ponitScreenX, ABS(self.currentValueMaxToViewY - (kLineModel.low.floatValue - self.currentValueMin) / self.unitValue));
        MTKLinePositionModel *positionModel = [[MTKLinePositionModel alloc] init];
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
    
    self.currentValueMin = minValue;
    self.currentValueMax = maxValue;
    
    return YES;
}
#pragma mark -
- (MTTechsShowView *)BOLLShowView {
    if (!_BOLLShowView) {
        _BOLLShowView = [[MTTechsShowView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        [self addSubview:_BOLLShowView];
    }
    
    return _BOLLShowView;
}

@end
