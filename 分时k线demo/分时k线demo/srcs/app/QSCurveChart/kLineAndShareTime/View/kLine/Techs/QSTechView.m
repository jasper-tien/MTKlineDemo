//
//  QSTechView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/19.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTechView.h"
#import "UIColor+CurveChart.h"
#import "QSTechBaseView.h"
#import "QSTechVolumeView.h"
#import "QSTechKDJView.h"
#import "QSTechBOLLView.h"
#import "QSTechMACDView.h"

@interface QSTechView () <QSTechBaseViewDelegate>
@property (nonatomic, assign) QSCurveTechType techType;
@property (nonatomic, strong) QSTechBaseView *showTechView;
@end

@implementation QSTechView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.techType = QSCurveTechType_KDJ; //默认成交量
    }
    
    return self;
}

//通过指标类型刷新指标视图
- (void)drawTechViewWithType:(QSCurveTechType)techType {
    if (techType != self.techType || !self.showTechView) {
        [self createShowTechView:techType];
    }
    
    switch (self.techType) {
        case QSCurveTechType_Volume: {
            QSTechVolumeView *techVolumeView = (QSTechVolumeView *)self.showTechView;
            techVolumeView.needDrawVolumeModels = self.needDrawTechModels;
            //刷新指标
            [techVolumeView drawTechView];
        }
            break;
        case QSCurveTechType_Jine: {
            
        }
            break;
        case QSCurveTechType_MACD: {
            QSTechMACDView *techVolumeView = (QSTechMACDView *)self.showTechView;
            techVolumeView.needDrawMACDModels = self.needDrawTechModels;
            //刷新指标
            [techVolumeView drawTechView];
        }
            break;
        case QSCurveTechType_KDJ: {
            QSTechKDJView *techKDJView = (QSTechKDJView *)self.showTechView;
            techKDJView.needDrawKDJModels = self.needDrawTechModels;
            //刷新指标
            [techKDJView drawTechView];
        }
            break;
        case QSCurveTechType_BOLL: {
            QSTechBOLLView *techBOLLView = (QSTechBOLLView *)self.showTechView;
            techBOLLView.needDrawBOLLModels = self.needDrawTechModels;
            techBOLLView.needDrawBOLLKlineModels = self.needDrawKlineModels;
            //刷新指标
            [techBOLLView drawTechView];
        }
            break;
        default:
            break;
    }
}

//切换指标，重新创建一个新的指标view
- (void)createShowTechView:(QSCurveTechType)techType {
    if (self.showTechView) {
        //移除原先的指标
        [self.showTechView removeFromSuperview];
    }
    
    switch (techType) {
        case QSCurveTechType_Volume: {
            self.showTechView = [[QSTechVolumeView alloc] initWithFrame:self.bounds];
            [self addSubview:self.showTechView];
        }
            break;
        case QSCurveTechType_Jine: {
            
        }
            break;
        case QSCurveTechType_MACD: {
            self.showTechView = [[QSTechMACDView alloc] initWithFrame:self.bounds];
            [self addSubview:self.showTechView];
        }
            break;
        case QSCurveTechType_KDJ: {
            self.showTechView = [[QSTechKDJView alloc] initWithFrame:self.bounds];
            [self addSubview:self.showTechView];
        }
            break;
        case QSCurveTechType_BOLL: {
            self.showTechView = [[QSTechBOLLView alloc] initWithFrame:self.bounds];
            [self addSubview:self.showTechView];
        }
            break;
        default: {
            
        }
            break;
    }
    self.showTechView.delegate = self;
    self.techType = techType;
}

- (void)reDrawTechShowViewWithIndex:(NSInteger)index {
    [self.showTechView reDrawShowViewWithIndex:index];
}

//长按，或者移动时调用
- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition{
    [self.showTechView longPressOrMovingAtPoint:longPressPosition];
}

#pragma mark - MTTechViewDelegate
- (void)techBaseViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressValue:(CGFloat)longPressValue {
    if (self.description && [self.delegate respondsToSelector:@selector(techViewLongPressExactPosition:selectedIndex:longPressValue:)]) {
        [self.delegate techViewLongPressExactPosition:longPressPosition selectedIndex:index longPressValue:longPressValue];
    }
}

@end
