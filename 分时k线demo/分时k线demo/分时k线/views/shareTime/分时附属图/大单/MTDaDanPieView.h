//
//  MTDaDanPieView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/26.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDaDanPieView : UIView
//圆的半径。如果设置半径大于默认半径后，当作默认半径来处理。
@property (nonatomic, assign) CGFloat radius;
//设置是否可以点击扇形区域,默认是可以的
@property (nonatomic, assign) BOOL isClick;
//点击某块扇形区域后，该扇形区域往外移动的偏移量,默认是5
@property (nonatomic, assign) CGFloat offsetRadius;

- (void)updatePie;

- (void)updatePieWithDatas:(NSArray<NSNumber *> *)datas colors:(NSArray<UIColor *> *)colors;

@end
