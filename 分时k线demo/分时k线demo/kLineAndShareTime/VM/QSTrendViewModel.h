//
//  QSTrendViewModel.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QSTrendViewModel;
@protocol QSTrendViewModelDelegate <NSObject>

@optional

@end

@interface QSTrendViewModel : QSBaseViewModel

- (void)loadShareTimeData;
- (void)loadKLineData;
- (void)loadKLastLineData;
- (void)loadNextKLineData;

@end

NS_ASSUME_NONNULL_END
