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
@property (nonatomic, assign) CGFloat priceMaxToViewY;
@property (nonatomic, assign) CGFloat priceMinToViewY;
@property (nonatomic, assign) CGFloat unitValue;
//前一天的收盘价
@property (nonatomic, assign) CGFloat previousClosePrice;
@end

@implementation MTTimeLineView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.drawPositionModels = @[].mutableCopy;
        
        self.priceMax = 0;
        self.priceMin = 0;
        self.priceMaxToViewY = self.frame.size.height - MTCurveChartKLineMainViewMinY;;
        self.priceMinToViewY = MTCurveChartKLineMainViewMinY;
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
    
    //昨收价
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor MTTimeLinePreviousClosePriceLineColor].CGColor);
    CGFloat maxY = self.frame.size.height - MTCurveChartKLineMainViewMinY;
    CGFloat previousClosePricePointY = ABS(maxY - (self.previousClosePrice - self.priceMin)/self.unitValue);
    CGContextMoveToPoint(ctx, 0, previousClosePricePointY);
    CGContextAddLineToPoint(ctx, self.frame.size.width, previousClosePricePointY);
    CGContextStrokePath(ctx);
    
    [self drawPositionYRuler];
}

- (void)drawPositionYRuler {
    NSString *priceMaxStr = [NSString stringWithFormat:@"%.2f", self.priceMax];
    CGPoint priceMaxPoint = CGPointMake(0, self.priceMinToViewY - 10);
    [priceMaxStr drawAtPoint:priceMaxPoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor mainTextColor]}];
    
    NSString *priceMinStr = [NSString stringWithFormat:@"%.2f", self.priceMin];
    CGPoint priceMinPoint = CGPointMake(0, self.priceMaxToViewY + 10);
    [priceMinStr drawAtPoint:priceMinPoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor mainTextColor]}];
}

/**
 更新需要绘制的数据源
 */
- (void)updateDrawModels {
    //更新最大值最小值-价格
    self.previousClosePrice = [self.timeLineModels.firstObject previousClosePrice];
    self.priceMax = [[[self.timeLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@max.floatValue"] floatValue];
    self.priceMin = [[[self.timeLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    [self convertToPositionModelsWithXPosition];
}

- (NSArray *)convertToPositionModelsWithXPosition {
    if (!self.timeLineModels) return nil;
    
    [self.drawPositionModels removeAllObjects];
    
    self.unitValue = (self.priceMax - self.priceMin)/(self.priceMaxToViewY - self.priceMinToViewY);
    [self.timeLineModels enumerateObjectsUsingBlock:^(MTTimeLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTTimeLineModel *model = obj;
        CGFloat xPosition = idx * ([MTCurveChartGlobalVariable timeLineVolumeWidth] + [MTCurveChartGlobalVariable timeLineVolumeGapWidth]);
        CGPoint pricePoint = CGPointMake(xPosition, ABS(self.priceMaxToViewY - (model.Price.floatValue - self.priceMin)/self.unitValue));
        [self.drawPositionModels addObject:[NSValue valueWithCGPoint:pricePoint]];
    }];
    
    [self setNeedsDisplay];
    
    return self.drawPositionModels ;
}

@end
