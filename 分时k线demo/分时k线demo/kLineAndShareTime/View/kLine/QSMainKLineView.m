//
//  QSMainKLineView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSMainKLineView.h"
#import "QSPointKLineModel.h"

@interface QSMainKLineView ()
@property (nonatomic, strong) QSPointKLineModel *viewModel;
@end

@implementation QSMainKLineView

- (instancetype)initWithViewModel:(QSPointKLineModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSPointKLineModel *)viewModel {
    if (self = [super initWithFrame:frame]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)bindVM:(QSPointKLineModel *)viewModel {
    self.viewModel = viewModel;
}

@end
