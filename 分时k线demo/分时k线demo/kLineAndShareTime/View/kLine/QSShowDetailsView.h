//
//  QSShowDetailsView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/4.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSShowDetailsView : UIView

@property (nonatomic, copy) NSArray *contentArray;
@property (nonatomic, assign) CGFloat startPointX;
- (instancetype)initWithFrame:(CGRect)frame;
//参数说明：需要绘制的内容通过该数组提供，数组的每个元素应该为一个字典，字典应该包括以下内容：
//  1、个体字符内容（如：成交量：3.13万手）
//  2、个体类型（目前有两种类型：1:纯字符类型。2:圆点+字符）
//  3、个体字符的颜色
- (void)redrawWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
