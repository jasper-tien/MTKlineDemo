//
//  MTTimeLineDetailedView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTimeLineDetailedView.h"
#import "MTTimeLineDetailedCell.h"

#define TimeLineDetailedCellID @"TimeLineDetailedCellID"

@interface MTTimeLineDetailedView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MTTimeLineDetailedView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

- (void)reloadTableView {
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.tableViewDatas.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 21;
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:NO];
    return self.tableViewDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTTimeLineDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:TimeLineDetailedCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.tableViewDatas[indexPath.row];
    cell.timeLabel.text = dataDic[@"time"];
    cell.priceLabel.text = dataDic[@"price"];
    cell.volumeLabel.text = dataDic[@"volume"];
    
    return cell;
}

#pragma mark -
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MTTimeLineDetailedCell" bundle:nil] forCellReuseIdentifier:TimeLineDetailedCellID];
    }
    
    return _tableView;
}

@end
