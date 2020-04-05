//
//  QSTrendKLineVM.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QSTrendKLineVM, QSKlineModel;
@protocol QSTrendKLineVMDelegate <NSObject>

@optional

- (void)kLineVM:(QSTrendKLineVM *)vm willUpdateView:(BOOL)isUpdate;
- (void)kLineVM:(QSTrendKLineVM *)vm didUpdateView:(BOOL)isUpdate;
- (void)kLineVM:(QSTrendKLineVM *)vm drawTopDetailsView:(QSKlineModel *)model;

@end

@class QSPointPositionKLineModel;
@class QSKlineModel;
@interface QSTrendKLineVM : QSBaseViewModel

@property (nonatomic, weak) id<QSTrendKLineVMDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableArray<QSPointPositionKLineModel *> *needDrawPositionModels;
@property (nonatomic, copy, readonly) NSArray<QSKlineModel *> *needDrawKlneModels;
@property (nonatomic, strong, readonly) NSMutableArray *MA5Positions; /// MA5位置数组
@property (nonatomic, strong, readonly) NSMutableArray *MA10Positions; /// MA10位置数组
@property (nonatomic, strong, readonly) NSMutableArray *MA20Positions; /// MA20位置数组
@property (nonatomic, assign, readonly) CGFloat currentPriceMax; /// 当前价格最大值
@property (nonatomic, assign, readonly) CGFloat currentPriceMin; /// 当前价格最小值
@property (nonatomic, assign, readonly) CGFloat currentPriceMaxToViewY; /// 当前价格最大值对应到视图上的纵坐标
@property (nonatomic, assign, readonly) CGFloat currentPriceMinToViewY; /// 当前价格最小值对应到视图上的纵坐标
@property (nonatomic, assign, readonly) CGFloat unitViewY; ///视图上单位坐标表示的价格值
@property (nonatomic, strong) QSKlineModel *showKlineModel; ///需要显示在顶部的model

#warning todo
@property (nonatomic, assign) CGRect frame;

- (void)reDrawShowViewWithIndex:(NSInteger)index;
- (void)drawView:(NSArray<QSKlineModel *>*)needDrawKlneModels;

@end

NS_ASSUME_NONNULL_END
