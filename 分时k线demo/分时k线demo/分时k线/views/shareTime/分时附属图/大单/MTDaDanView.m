//
//  MTDaDanView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTDaDanView.h"
#import "MTDaDanPieView.h"
#import "MTTimeLineDetailedCell.h"
#import "UIColor+CurveChart.h"

#define TimeLineDaDanDetailedCellID @"MTTimeLineDaDanDetailedCell"

@interface MTDaDanView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MTDaDanPieView *pieView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MTDaDanView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.pieView updatePieWithDatas:[NSArray arrayWithObjects:@(20), @(50), nil] colors:[NSArray arrayWithObjects:[UIColor purpleColor],[UIColor orangeColor], nil]];
    }
    
    return self;
}

- (void)reloadTableView {
    [self.tableView reloadData];
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
    MTTimeLineDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:TimeLineDaDanDetailedCellID forIndexPath:indexPath];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _tableView.tableHeaderView = self.pieView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MTTimeLineDetailedCell" bundle:nil] forCellReuseIdentifier:TimeLineDaDanDetailedCellID];
    }
    
    return _tableView;
}

- (MTDaDanPieView *)pieView {
    if (!_pieView) {
        _pieView = [[MTDaDanPieView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        _pieView.radius = self.frame.size.width / 2 - 10;
        
        UIView *segmentationView = [[UIView alloc] initWithFrame:CGRectMake(5, _pieView.frame.size.height - 5, _pieView.frame.size.width, 0.7)];
        segmentationView.backgroundColor = [UIColor gridLineColor];
        [_pieView addSubview:segmentationView];
    }
    
    return _pieView;
}

@end
