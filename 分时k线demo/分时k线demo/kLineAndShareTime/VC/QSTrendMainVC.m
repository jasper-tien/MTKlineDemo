//
//  QSTrendMainVC.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSTrendMainVC.h"
#import "QSTrendViewModel.h"

@interface QSTrendMainVC ()

@property (nonatomic, strong) QSTrendViewModel *viewModel;

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
}

- (void)makeViewModel {
    if (!self.viewModel) {
        self.viewModel = [[QSTrendViewModel alloc] init];
    }
}

@end
