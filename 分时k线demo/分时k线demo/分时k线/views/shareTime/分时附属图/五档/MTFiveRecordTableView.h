//
//  MTFiveRecordTableView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTFiveRecordModel;
@interface MTFiveRecordTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MTFiveRecordModel *fiveRecordModel;
- (void)reDrawWithFiveRecordModel:(MTFiveRecordModel *)fiveRecordModel;
@end
