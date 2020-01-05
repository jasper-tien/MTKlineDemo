//
//  QSTrendMainVC.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendMainVC.h"
#import "QSTrendViewModel.h"
#import "QSMainKLineView.h"

@interface QSTrendMainVC ()

@property (nonatomic, strong) QSTrendViewModel *viewModel;
@property (nonatomic, strong) QSMainKLineView *mainKLineView;

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
    [self makeMainKLineView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel loadKLineData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mainKLineView.frame = CGRectMake(0, 50, self.view.frame.size.width, 200);
}

- (void)makeViewModel {
    if (!self.viewModel) {
        self.viewModel = [[QSTrendViewModel alloc] init];
    }
}

- (void)makeMainKLineView {
    if (!self.mainKLineView) {
        self.mainKLineView = [[QSMainKLineView alloc] initWithViewModel:self.viewModel.kLineVM];
        [self.view addSubview:self.mainKLineView];
    }
}

@end
