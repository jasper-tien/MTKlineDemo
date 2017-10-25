//
//  MTTimeLineTableView.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "MTTimeLineTableView.h"
#import "MTFiveRecordTableView.h"
#import "MTFiveRecordModel.h"
#import "MTTimeLineDetailedView.h"
#import "MTDaDanView.h"

#define CurrentContentViewTag 10000
@interface MTTimeLineTableView ()
@property (nonatomic, strong) MTFiveRecordTableView *fiveRecordTableView;
@property (nonatomic, strong) MTTimeLineDetailedView *detailedView;
@property (nonatomic, strong) MTDaDanView *daDanView;
@property (nonatomic, copy) NSArray *subViewArray;
@property (nonatomic, copy) NSArray *subViewButtonArray;
//当前选中view的index
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MTTimeLineTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedIndex = 0;
        [self initUI];
        
        
        //点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)initUI {
    CGFloat btnWidth = self.frame.size.width / 3;
    NSArray *titleArr = @[@"五档" ,@"明细", @"大单"];
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth * i, self.frame.size.height - 21, btnWidth, 21)];
        btn.tag = 1000 + i;
        btn.selected = NO;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:86/255.0 green:153/255.0 blue:196/255.0 alpha:1] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [buttons addObject:btn];
        
        if (0 == i) {
            //默认选中按钮
            btn.selected = YES;
        }
    }
    self.subViewButtonArray = buttons;
    
    self.subViewArray = [NSArray arrayWithObjects:self.fiveRecordTableView, self.detailedView, self.daDanView, nil];
    
    //默认显示view
    [self addSubview:self.fiveRecordTableView];
}

- (void)switchSubViewWithIndex:(NSInteger)index {
    UIView *previousShowView = [self viewWithTag:CurrentContentViewTag];
    if (previousShowView) {
        [previousShowView removeFromSuperview];
    }
    UIView *currentShowView = self.subViewArray[index];
    [self addSubview:currentShowView];
}

#pragma mark -
- (void)clickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.selectedIndex = sender.tag - 1000;
    for (int i = 0; i < self.subViewButtonArray.count; i++) {
        UIButton *btn = self.subViewButtonArray[i];
        if (btn != sender) {
            btn.selected = NO;
        }
    }
    [self switchSubViewWithIndex:self.selectedIndex];
}

- (void)tapMethod:(UITapGestureRecognizer *)tapGesture {
    self.selectedIndex++;
    UIButton *selectedBtn = self.subViewButtonArray[self.selectedIndex];
    selectedBtn.selected = YES;
    for (int i = 0; i < self.subViewButtonArray.count; i++) {
        UIButton *btn = self.subViewButtonArray[i];
        if (btn != selectedBtn) {
            btn.selected = NO;
        }
    }
    
    [self switchSubViewWithIndex:self.selectedIndex];
}

- (NSArray *)getDetailedData {
    NSInteger minute = 12;
    NSInteger second = 0;
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
        NSString *price = [NSString stringWithFormat:@"%u", (arc4random() % 50) + 100];
        NSString *volume = [NSString stringWithFormat:@"%u", (arc4random() % 50) + 10];
        
        second++;
        if (second > 60) {
            second = 0;
            minute++;
            if (minute > 24) {
                minute = 0;
            }
        }
        NSString *time = [NSString stringWithFormat:@"%02lu:%02lu", minute, second];
        NSDictionary *dic = @{
                              @"time"  : time,
                              @"price" : price,
                              @"volume" : volume
                              };
        [datas addObject:dic];
    }
    
    return datas;
}

#pragma mark -
- (MTFiveRecordTableView *)fiveRecordTableView {
    if (!_fiveRecordTableView) {
        _fiveRecordTableView = [[MTFiveRecordTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 21) style:UITableViewStyleGrouped];
        _fiveRecordTableView.tag = CurrentContentViewTag;
        MTFiveRecordModel *model = [[MTFiveRecordModel alloc] init];
        model.BuyPriceArray = @[@"58.15", @"58.12", @"58.09", @"58.08", @"58.13"];
        model.SellPriceArray = @[@"58.08", @"58.07", @"58.06", @"58.05", @"58.10"];
        
        model.BuyVolumeArray = @[@"13", @"15", @"3", @"17", @"2"];
        model.SellVolumeArray = @[@"148", @"86", @"143", @"105", @"62"];
        model.BuyDescArray = @[@"买1", @"买2", @"买3", @"买4", @"买5"];
        model.SellDescArray = @[@"卖1", @"卖2", @"卖3", @"卖4", @"卖5", ];
        _fiveRecordTableView.fiveRecordModel = model;
        [_fiveRecordTableView reDrawWithFiveRecordModel:model];
    }
    
    return _fiveRecordTableView;
}

- (MTTimeLineDetailedView *)detailedView {
    if (!_detailedView) {
        _detailedView = [[MTTimeLineDetailedView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 21)];
        _detailedView.tag = CurrentContentViewTag;
        _detailedView.tableViewDatas = [self getDetailedData];
        [_detailedView reloadTableView];
    }
    
    return _detailedView;
}

- (MTDaDanView *)daDanView {
    if (!_daDanView) {
        _daDanView = [[MTDaDanView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 21)];
        _detailedView.tag = CurrentContentViewTag;
    }
    
    return _daDanView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= self.subViewArray.count || selectedIndex >= self.subViewButtonArray.count) {
        _selectedIndex = 0;
    }else {
        _selectedIndex = selectedIndex;
    }
}

@end
