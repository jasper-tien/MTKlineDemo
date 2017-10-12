//
//  MTTechView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/11.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTechView.h"
#import "UIColor+CurveChart.h"
#import "MTTechBaseView.h"
#import "MTTechVolumeView.h"

@interface MTTechView ()
@property (nonatomic, assign) SJCurveTechType techType;
@property (nonatomic, strong) MTTechBaseView *showTechView;
@end

@implementation MTTechView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor backgroundColor];
        self.techType = SJCurveTechType_Volume; //默认成交量
    }
    
    return self;
}

//通过指标类型刷新指标视图
- (void)drawTechViewWithType:(SJCurveTechType)techType {
    if (techType != self.techType) {
        [self createShowTechView:techType];
    }
    
    //刷新指标
    [self.showTechView drawTechView];
}

//切换指标，重新创建一个新的指标view
- (void)createShowTechView:(SJCurveTechType)techType {
    if (self.showTechView) {
        //移除原先的指标
        [self.showTechView removeFromSuperview];
    }
    
    switch (techType) {
        case SJCurveTechType_Volume: {
            self.showTechView = [[MTTechVolumeView alloc] initWithFrame:self.bounds];
            [self addSubview:self.showTechView];
        }
            break;
        case SJCurveTechType_Jine: {
            
        }
            break;
        case SJCurveTechType_MACD: {
            
        }
            break;
        case SJCurveTechType_KDJ: {
            
        }
            break;
        case SJCurveTechType_BOLL: {
            
        }
            break;
        default:
            break;
    }
    
    self.techType = techType;
}

@end
