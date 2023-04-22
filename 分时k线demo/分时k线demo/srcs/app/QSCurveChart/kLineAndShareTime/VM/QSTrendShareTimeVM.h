//
//  QSTrendShareTimeVM.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewModel.h"
#import "QSTrendViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class QSTrendShareTimeVM;
@protocol QSTrendShareTimeVMDelegate <NSObject>

@optional

- (void)shareTimeVM:(QSTrendShareTimeVM *)vm willUpdate:(BOOL)isUpdate;
- (void)shareTimeVM:(QSTrendShareTimeVM *)vm didUpdate:(BOOL)isUpdate;

@end

@class QSPointShareTimeModel;
@interface QSTrendShareTimeVM : QSBaseViewModel<QSTrendViewModelCastProtocol>

- (void)updateData:(NSArray<QSPointShareTimeModel *> *)datas;

@end

NS_ASSUME_NONNULL_END
