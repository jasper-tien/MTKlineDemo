//
//  QSTrendViewModel.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendViewModel.h"
#import "QSPointKLineModel.h"
#import "QSPointShareTimeModel.h"
#import "QSTrendShareTimeVM.h"
#import "QSTrendKLineVM.h"

@interface QSTrendViewModel()
@property (nonatomic, strong) QSTrendShareTimeVM *shareTimeVM;
@property (nonatomic, strong) QSTrendKLineVM *kLineVM;
@end

@implementation QSTrendViewModel

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Public Metheds

- (void)loadShareTimeData {
    
}

- (void)loadKLineData {
    
}

- (void)loadKLastLineData {
    
}

- (void)loadNextKLineData {
    
}

#pragma mark - Private Methods

- (void)loadData {
    
}

- (void)loadMoreData {
    
}

- (void)makeShareTimeVM {
    if (!self.shareTimeVM) {
        self.shareTimeVM = [[QSTrendShareTimeVM alloc] init];
    }
}

- (void)makeKLineVM {
    if (!self.kLineVM) {
        self.kLineVM = [[QSTrendKLineVM alloc] init];
    }
}

#pragma mark - Make Data

- (nonnull NSArray<QSPointShareTimeModel *> *)createShareTimeDataSource:(NSInteger)count {
    if (count <= 0) {
        return @[];
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        CGFloat price = 0;
        CGFloat volume = 0;
        if (i < 20) {
            price = (arc4random() % 10) + 60;
            volume = (arc4random() % 60) + 10;
        } else if (i > 20 && i < 60) {
            price = (arc4random() % 10) + 20;
            volume = arc4random() % 10 + 20;
        }else {
            price = (arc4random() % 10) +10;
            volume = (arc4random() % 10) +10;
        }
        NSString *date = @"10:30";
        QSPointShareTimeModel *model = [[QSPointShareTimeModel alloc] init];
        model.price = price;
        model.preClosePrice = 50;
        model.volume = volume;
        model.time = date;
        [models addObject:model];
    }
    
    return models;
}

- (nonnull NSArray<QSPointKLineModel *> *)createKLineDataSource:(NSInteger)count {
    if (count <= 0) {
        return @[];
    }
    
    NSMutableArray<QSPointKLineModel *> *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        int open = (arc4random() % 1000) + 1;
        int close = (arc4random() % 1000) + 1;
        CGFloat high = 0;
        CGFloat low = 0;
        if (ABS(close - open) > 300) {
            if (close > open) {
                close = open + arc4random() % 300;
                
                high = close + arc4random() % 50;
                
                int lo = open - arc4random() % 50;
                if (lo <= 0) {
                    lo = 0;
                }
                low = lo;
                
            }else {
                open = close + arc4random() % 300;
                
                high = open + arc4random() % 50;
                
                int lo = close - arc4random() % 50;
                if (lo <= 0) {
                    lo = 0;
                }
                low = lo;
            }
        }
        
        CGFloat volume = (arc4random() % 100) + 500;
        NSString *time = [NSString stringWithFormat:@"%d", (arc4random() % 1000) + 1];
        
        QSPointKLineModel *model = [[QSPointKLineModel alloc] init];
        model.open = open;
        model.high = high;
        model.low = low;
        model.close = close;
        model.volume = volume;
        model.time = time;
        [array addObject:model];
    }
    
    return array;
}

@end
