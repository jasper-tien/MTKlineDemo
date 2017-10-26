//
//  MTDaDanPieView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/26.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTDaDanPieView.h"
@interface MTDaDanPieView ()
@property (nonatomic, copy) NSArray<NSNumber *> *datas;
@property (nonatomic, copy) NSArray<UIColor *> *colors;
@property (nonatomic, strong) CAShapeLayer *supPieLayer;
@end

@implementation MTDaDanPieView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (frame.size.height != frame.size.width) {
            if (frame.size.height > frame.size.width) {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.width);
            } else {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.height, self.frame.size.height);
            }
        }
        self.datas = @[].copy;
        self.colors = @[].copy;
        self.offsetRadius = 5;
        self.isClick = YES;
        self.radius = self.frame.size.width / 2.0 - self.offsetRadius;
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (void)updatePie {
    [self updatePieWithDatas:self.datas colors:self.colors];
}

- (void)updatePieWithDatas:(NSArray<NSNumber *> *)datas colors:(NSArray<UIColor *> *)colors {
    if (datas.count <=0 || colors.count <= 0 || datas.count != colors.count) {
        return;
    }
    [self drawSectorLayers:datas colors:colors];
}

//画图
- (void)drawSectorLayers:(NSArray<NSNumber *> *)datas colors:(NSArray<UIColor *> *)colors {
    
    NSArray *sectorDataArray = [self sectorPositionWithDatas:datas colors:colors];
    if (sectorDataArray.count <= 0) {
        return;
    }
    
    for (CALayer *layer in self.supPieLayer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    for (int i = 0; i < sectorDataArray.count; i ++) {
        NSDictionary *sectorDataDic = sectorDataArray[i];
        CAShapeLayer *sectorLayer = [CAShapeLayer layer];
        UIBezierPath *sectorPath = [UIBezierPath bezierPath];
        [sectorPath moveToPoint:self.center];
        [sectorPath addArcWithCenter:self.center radius:self.radius startAngle:[sectorDataDic[@"startAngle"] floatValue] endAngle:[sectorDataDic[@"endAngle"] floatValue] clockwise:YES];
        sectorLayer.fillColor = [sectorDataDic[@"color"] CGColor];
        sectorLayer.path = sectorPath.CGPath;
        [self.layer addSublayer:sectorLayer];
    }
}

//计算每个扇形区域的位置信息
- (NSArray *)sectorPositionWithDatas:(NSArray<NSNumber *> *)datas colors:(NSArray<UIColor *> *)colors {
    //计算总和
    __block CGFloat sum = 0;
    [datas enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sum += obj.floatValue;
    }];
    
    CGFloat startAngle = 0;
    CGFloat endAngle = startAngle;
    NSMutableArray *sectorDataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < datas.count; i++) {
        NSNumber *num = datas[i];
        CGFloat sectorAngle = M_PI*2 / sum * num.floatValue;
        endAngle = startAngle + sectorAngle;
        NSDictionary *sectorDataDic = @{
                                    @"startAngle" : @(startAngle),
                                    @"endAngle" : @(endAngle),
                                    @"color" : colors[i],
                                    };
        [sectorDataArray addObject:sectorDataDic];
        startAngle = endAngle;
    }
    
    return sectorDataArray;
}

#pragma mark - setters and getters
- (CAShapeLayer *)supPieLayer {
    if (!_supPieLayer) {
        _supPieLayer = [CAShapeLayer layer];
        UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.bounds.size.width/4.f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
        _supPieLayer.path = piePath.CGPath;
        [self.layer addSublayer:_supPieLayer];
    }
    
    return _supPieLayer;
}
- (void)setRadius:(CGFloat)radius {
    if (radius > (self.frame.size.width / 2 - self.offsetRadius)) {
        return;
    }
    
    _radius = radius;
}

- (void)setOffsetRadius:(CGFloat)offsetRadius {
    if (offsetRadius > (self.frame.size.width / 2)) {
        return;
    }
    _offsetRadius = offsetRadius;
}

- (void)setIsClick:(BOOL)isClick {
    if (!isClick) {
        self.offsetRadius = 0;
    }
    _isClick = isClick;
}

@end
