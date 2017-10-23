//
//  MTTimeLineView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTimeLineView.h"
#import "UIColor+CurveChart.h"
#import "MTTimeLineModel.h"
#import "SJCurveChartConstant.h"
#import "MTCurveChartGlobalVariable.h"

@interface MTTimeLineView ()
@property (nonatomic, strong) NSMutableArray *drawPositionModels;

@property (nonatomic, assign) CGFloat priceMax;
@property (nonatomic, assign) CGFloat priceMin;
@end

@implementation MTTimeLineView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.drawPositionModels = @[].mutableCopy;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!self.drawPositionModels) {
        return;
    }
    
    CGContextSetLineWidth(ctx, MTCurveChartTimeLineWidth);
    CGPoint firstPoint = [self.drawPositionModels.firstObject CGPointValue];
    
    if (isnan(firstPoint.x) || isnan(firstPoint.y)) {
        return;
    }
    NSAssert(!isnan(firstPoint.x) && !isnan(firstPoint.y), @"出现NAN值：MA画线");
    
    //画分时线
    CGContextSetStrokeColorWithColor(ctx, [UIColor MTTimeLineColor].CGColor);
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    for (NSInteger idx = 1; idx < self.drawPositionModels.count ; idx++)
    {
        CGPoint point = [self.drawPositionModels[idx] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextStrokePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [UIColor MTTimeLineBgColor].CGColor);
    CGPoint lastPoint = [self.drawPositionModels.lastObject CGPointValue];
    //画背景色
    CGContextMoveToPoint(ctx, firstPoint.x, firstPoint.y);
    for (NSInteger idx = 1; idx < self.drawPositionModels.count ; idx++)
    {
        CGPoint point = [self.drawPositionModels[idx] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextAddLineToPoint(ctx, lastPoint.x, CGRectGetMaxY(self.frame));
    CGContextAddLineToPoint(ctx, firstPoint.x, CGRectGetMaxY(self.frame));
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

/**
 更新需要绘制的数据源
 */
- (void)updateDrawModels {
    //更新最大值最小值-价格
    CGFloat average = [self.timeLineModels.firstObject AvgPrice];
    self.priceMax = [[[self.timeLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@max.floatValue"] floatValue];
    self.priceMin = [[[self.timeLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    [self convertToPositionModelsWithXPosition];
}

- (NSArray *)convertToPositionModelsWithXPosition {
    if (!self.timeLineModels) return nil;
    
    [self.drawPositionModels removeAllObjects];
    
    CGFloat minY = MTCurveChartKLineMainViewMinY;
    CGFloat maxY = self.frame.size.height - MTCurveChartKLineMainViewMinY;
    CGFloat unitValue = (self.priceMax - self.priceMin)/(maxY - minY);
    [self.timeLineModels enumerateObjectsUsingBlock:^(MTTimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTTimeLineModel *model = obj;
        CGFloat xPosition = idx * ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
        CGPoint pricePoint = CGPointMake(xPosition, ABS(maxY - (model.Price.floatValue - self.priceMin)/unitValue));
        [self.drawPositionModels addObject:[NSValue valueWithCGPoint:pricePoint]];
    }];
    
    [self setNeedsDisplay];
    
    return self.drawPositionModels ;
}

@end
