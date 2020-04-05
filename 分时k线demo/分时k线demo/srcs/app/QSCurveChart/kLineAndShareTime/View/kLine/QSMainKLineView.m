//
//  QSMainKLineView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSMainKLineView.h"
#import "QSCurveChartGlobalVariable.h"
#import "QSTrendKLineVM.h"
#import "UIColor+CurveColor.h"
#import "QSKlineModel.h"
#import "QSShowDetailsView.h"
#import "QSKLine.h"
#import "QSMALine.h"

@interface QSMainKLineView ()<QSTrendKLineVMDelegate>

@property (nonatomic, strong) QSTrendKLineVM *viewModel;
@property (nonatomic, strong) QSShowDetailsView *showDetailsView;

@end

@implementation QSMainKLineView

- (instancetype)initWithViewModel:(QSTrendKLineVM *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
        self.viewModel.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendKLineVM *)viewModel {
    if (self = [super initWithFrame:frame]) {
        self.viewModel = viewModel;
        self.viewModel.delegate = self;
    }
    return self;
}

- (void)bindVM:(QSTrendKLineVM *)viewModel {
    self.viewModel = viewModel;
    self.viewModel.delegate = self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.viewModel && self.viewModel.needDrawPositionModels.count <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGrid:context];//绘制框
    
    [self drawTopdeTailsView];//绘制顶部详情信息
    
    [self drawCandle:context];//绘制蜡烛
    
    [self drawMA:context];//绘制均线
    
    [self drawPositionYRuler:context];//绘制y轴尺标
}

- (void)drawGrid:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
    CGFloat gridLineWidth = [QSCurveChartGlobalVariable CurveChactGridLineWidth];
    CGContextSetLineWidth(context, gridLineWidth);
    CGContextAddRect(context, CGRectMake(gridLineWidth, gridLineWidth, self.frame.size.width - gridLineWidth, self.frame.size.height - 2*gridLineWidth));
    CGContextStrokePath(context);
    
    //先写死两条横线位置看看效果
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints1[] = {CGPointMake(0, self.bounds.size.height * 1 / 3), CGPointMake(self.bounds.size.width, self.bounds.size.height * 1 / 3)};
    CGContextStrokeLineSegments(context, gridKlinePoints1, 2);
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints2[] = {CGPointMake(0, self.bounds.size.height * 2 / 3), CGPointMake(self.bounds.size.width, self.bounds.size.height * 2 / 3)};
    CGContextStrokeLineSegments(context, gridKlinePoints2, 2);
    
    //先写死两条竖线位置看看效果
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints3[] = {CGPointMake(self.bounds.size.width * 1 / 3, 0), CGPointMake(self.bounds.size.width * 1 / 3, self.bounds.size.height)};
    CGContextStrokeLineSegments(context, gridKlinePoints3, 2);
    CGContextSetLineWidth(context, [QSCurveChartGlobalVariable CurveChactGridLineWidth]);
    const CGPoint gridKlinePoints4[] = {CGPointMake(self.bounds.size.width * 2 / 3, 0), CGPointMake(self.bounds.size.width * 2 / 3, self.bounds.size.height)};
    CGContextStrokeLineSegments(context, gridKlinePoints4, 2);
    
    const CGPoint gridKlinePoints5[] = {CGPointMake(0, self.viewModel.currentPriceMaxToViewY), CGPointMake(self.bounds.size.width, self.viewModel.currentPriceMaxToViewY)};
    CGContextStrokeLineSegments(context, gridKlinePoints5, 2);
    const CGPoint gridKlinePoints6[] = {CGPointMake(0, self.viewModel.currentPriceMinToViewY), CGPointMake(self.bounds.size.width, self.viewModel.currentPriceMinToViewY)};
    CGContextStrokeLineSegments(context, gridKlinePoints6, 2);
    
}

- (void)drawTopdeTailsView {
    NSDictionary *MA5Dic = @{
                           @"content" : [NSString stringWithFormat:@"MA5:%.2f", self.viewModel.showKlineModel.MA_5],
                           @"color":[UIColor QSCurveVioletColor],
                           @"type":@"1"
                           };
    NSDictionary *MA10Dic = @{
                           @"content" : [NSString stringWithFormat:@"MA10:%.2f", self.viewModel.showKlineModel.MA_10],
                           @"color":[UIColor QSCurveYellowColor],
                           @"type":@"1"
                           };
    NSDictionary *MA20Dic = @{
                           @"content" : [NSString stringWithFormat:@"MA20:%.2f", self.viewModel.showKlineModel.MA_20],
                           @"color":[UIColor QSCurveBlueColor],
                           @"type":@"1"
                           };
    NSArray *contentAarray = [NSArray arrayWithObjects:MA5Dic, MA10Dic, MA20Dic, nil];
    [self.showDetailsView redrawWithArray:contentAarray];
}

- (void)drawCandle:(CGContextRef)context {
    QSKLine *kLine = [[QSKLine alloc] initWithContext:context];
    [self.viewModel.needDrawPositionModels enumerateObjectsUsingBlock:^(QSPointPositionKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QSPointPositionKLineModel *positionModel = obj;
        kLine.positionModel = positionModel;
        [kLine draw];
    }];
}

- (void)drawMA:(CGContextRef)context {
    QSMALine *MALine = [[QSMALine alloc] initWithContext:context];
    MALine.techType = QSCurveTechType_KLine;
    MALine.MAType = MT_MA5Type;
    MALine.MAPositions = self.viewModel.MA5Positions;
    [MALine draw];
    
    MALine.MAType = MT_MA10Type;
    MALine.MAPositions = self.viewModel.MA10Positions;
    [MALine draw];
    
    MALine.MAType = MT_MA20Type;
    MALine.MAPositions = self.viewModel.MA20Positions;
    [MALine draw];
}

- (void)drawPositionYRuler:(CGContextRef)context {
    // 同样先全部写死，看看效果，后面根据需求更改
    CGFloat unitValueY = (self.viewModel.currentPriceMax - self.viewModel.currentPriceMin) / 3;
    CGFloat rulerValueY0 = self.viewModel.currentPriceMin;
    CGFloat rulerValueY1 = self.viewModel.currentPriceMin + unitValueY;
    CGFloat rulerValueY2 = self.viewModel.currentPriceMin + unitValueY * 2;
    CGFloat rulerValueY3 = self.viewModel.currentPriceMax;
    NSArray *rulerValueYs = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.2f", rulerValueY0] ,[NSString stringWithFormat:@"%.2f", rulerValueY1], [NSString stringWithFormat:@"%.2f",rulerValueY2], [NSString stringWithFormat:@"%.2f", rulerValueY3], nil];
    CGFloat unitPositionYRuler = self.frame.size.height / 3;
    for (NSInteger i = 0; i < rulerValueYs.count ; i++) {
        NSString *positionYStr = rulerValueYs[rulerValueYs.count - i - 1];
        CGPoint drawTitlePoint = CGPointMake(0, unitPositionYRuler * i);
        if (i == 3) {
            drawTitlePoint = CGPointMake(0, unitPositionYRuler * i - 15);
        }
        
        [positionYStr drawAtPoint:drawTitlePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor mainTextColor]}];
    }
}

#pragma mark - QSTrendKLineVMDelegate

- (void)kLineVM:(QSTrendKLineVM *)vm willUpdateView:(BOOL)isUpdate {
    
}

- (void)kLineVM:(QSTrendKLineVM *)vm didUpdateView:(BOOL)isUpdate {
    [self setNeedsDisplay];
}

- (void)kLineVM:(QSTrendKLineVM *)vm drawTopDetailsView:(QSKlineModel *)model {
    [self drawTopdeTailsView];
}

#pragma mark -

- (QSShowDetailsView *)showDetailsView {
    if (!_showDetailsView) {
        _showDetailsView = [[QSShowDetailsView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _showDetailsView.startPointX = 40;
        [self addSubview:_showDetailsView];
    }
    
    return _showDetailsView;
}

@end
