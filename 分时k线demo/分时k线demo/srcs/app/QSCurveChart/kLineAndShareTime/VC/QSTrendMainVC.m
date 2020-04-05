//
//  QSTrendMainVC.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendMainVC.h"
#import "QSTrendViewModel.h"
#import "QSKLineView.h"

@interface QSTrendMainVC ()

@property (nonatomic, strong) QSTrendViewModel *viewModel;
@property (nonatomic, strong) QSKLineView *kLineView;

@end

@implementation QSTrendMainVC


- (instancetype)init {
    if (self = [super init]) {
        [self makeViewModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeKLineView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel loadKLineData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)makeViewModel {
    if (!self.viewModel) {
        self.viewModel = [[QSTrendViewModel alloc] init];
    }
}

- (void)makeKLineView {
    if (!self.kLineView) {
        self.kLineView = [[QSKLineView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 400) viewModel:self.viewModel];
        [self.view addSubview:self.kLineView];
    }
}

@end
