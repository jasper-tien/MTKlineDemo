//
//  QSTrendShareTimeVM.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendShareTimeVM.h"
#import "QSPointShareTimeModel.h"

@interface QSTrendShareTimeVM()

@end

@implementation QSTrendShareTimeVM

- (void)updateData:(NSArray<QSPointShareTimeModel *> *)datas {
    
}

#pragma mark - QSTrendViewModelCastProtocol

- (void)m_castNeedUpdateIfNeed {
    NSLog(@"QSTrendShareTimeVM m_castNeedUpdateIfNeed");
}

@end
