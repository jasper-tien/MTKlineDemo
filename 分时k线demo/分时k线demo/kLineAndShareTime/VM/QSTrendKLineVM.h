//
//  QSTrendKLineVM.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QSTrendKLineVM;
@protocol QSTrendKLineVMDelegate <NSObject>

@optional

- (void)kLineVM:(QSTrendKLineVM *)vm willUpdate:(BOOL)isUpdate;
- (void)kLineVM:(QSTrendKLineVM *)vm didUpdate:(BOOL)isUpdate;

@end

@class QSPointKLineModel;
@class QSPointPositionKLineModel;
@interface QSTrendKLineVM : QSBaseViewModel

@property (nonatomic, strong, readonly) NSMutableArray<QSPointPositionKLineModel *> *needDrawPositionModels;
@property (nonatomic, strong, readonly) NSMutableArray *MA5Positions; /// MA5位置数组
@property (nonatomic, strong, readonly) NSMutableArray *MA10Positions; /// MA10位置数组
@property (nonatomic, strong, readonly) NSMutableArray *MA20Positions; /// MA20位置数组
@property (nonatomic, assign, readonly) CGFloat currentPriceMax; /// 当前价格最大值
@property (nonatomic, assign, readonly) CGFloat currentPriceMin; /// 当前价格最小值
@property (nonatomic, assign, readonly) CGFloat currentPriceMaxToViewY; /// 当前价格最大值对应到视图上的纵坐标
@property (nonatomic, assign, readonly) CGFloat currentPriceMinToViewY; /// 当前价格最小值对应到视图上的纵坐标
@property (nonatomic, assign, readonly) CGFloat unitViewY; ///视图上单位坐标表示的价格值

- (void)updateData:(NSArray<QSPointKLineModel *> *)datas;
- (void)updateDataWithNextData:(NSArray<QSPointKLineModel *> *)datas;
- (void)updateDataWithLastData:(NSArray<QSPointKLineModel *> *)datas;

@end

NS_ASSUME_NONNULL_END
