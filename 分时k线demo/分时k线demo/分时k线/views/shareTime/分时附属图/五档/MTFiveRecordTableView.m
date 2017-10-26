//
//  MTFiveRecordTableView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTFiveRecordTableView.h"
#import "MTFiveRecordCell.h"
#import "MTFiveRecordModel.h"
#import "UIColor+CurveChart.h"

#define FiveRecordCellIdentifier @"FiveRecordCellIdentifier"

@implementation MTFiveRecordTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate =self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    
    return self;
}

- (void)reDrawWithFiveRecordModel:(MTFiveRecordModel *)fiveRecordModel {
    if (fiveRecordModel || _fiveRecordModel == fiveRecordModel) {
        _fiveRecordModel = fiveRecordModel;
        [self reloadData];
    }
}

#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height / 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_fiveRecordModel) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *segmentationView = [[UIView alloc] init];
        segmentationView.backgroundColor = [UIColor gridLineColor];
        return segmentationView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self dequeueReusableCellWithIdentifier:FiveRecordCellIdentifier]) {
        [self registerNib:[UINib nibWithNibName:@"MTFiveRecordCell" bundle:nil] forCellReuseIdentifier:FiveRecordCellIdentifier];
    }
    MTFiveRecordCell *cell = [self dequeueReusableCellWithIdentifier:FiveRecordCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.buyOrSellLabel.text = [self.fiveRecordModel SellDescArray][indexPath.row];
        cell.priceLabel.text = [self.fiveRecordModel SellPriceArray][indexPath.row];
        cell.volumeLabel.text = [self.fiveRecordModel SellVolumeArray][indexPath.row];
    } else {
        cell.buyOrSellLabel.text = [self.fiveRecordModel BuyDescArray][indexPath.row];
        cell.priceLabel.text = [self.fiveRecordModel BuyPriceArray][indexPath.row];
        cell.volumeLabel.text = [self.fiveRecordModel BuyVolumeArray][indexPath.row];
    }
    return cell;
}

@end
