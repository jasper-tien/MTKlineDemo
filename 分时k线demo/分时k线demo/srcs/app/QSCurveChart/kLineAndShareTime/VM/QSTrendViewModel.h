//
//  QSTrendViewModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewModel.h"
#import "QSConstant.h"
#import "QSTrendViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class QSTrendViewModel;
@protocol QSTrendViewModelDelegate <NSObject>

@optional 

@end

@class QSTrendShareTimeVM;
@class QSTrendKLineVM;
@class QSTrackingCrossVM;
@interface QSTrendViewModel : QSBaseViewModel<QSTrendViewModelProtocol>
@property (nonatomic, strong, readonly) QSTrendShareTimeVM *shareTimeVM;
@property (nonatomic, strong, readonly) QSTrendKLineVM *kLineVM;
@property (nonatomic, strong, readonly) QSTrackingCrossVM *trackingCrossVM;
@property (nonatomic, copy, readonly) NSDictionary *techsDataModelDic;

- (void)loadShareTimeData;
- (void)loadKLineData;
- (void)loadKLastLineData;
- (void)loadNextKLineData;

- (NSArray *)getMainKLineDatas;

- (void)drawKLineWithRange:(QSRange)range;
- (void)drawKLineWithRange:(NSRange)range direction:(QSRangeDirection)direction;

- (NSArray *)getBOLLDatasWithRange:(NSRange)range;
- (NSArray *)getKDJDatasWithRange:(NSRange)range;
- (NSArray *)getMACDDatasWithRange:(NSRange)range;
- (NSArray *)getMainKLineDatasWithRange:(NSRange)range;

- (void)addDelegate:(id<QSTrendViewModelCastProtocol>)delegate;

@end

NS_ASSUME_NONNULL_END
