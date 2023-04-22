//
//  QSBaseViewController.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSBaseViewController.h"

@interface QSBaseViewController ()

@property (nonatomic, strong, readwrite) QSCurveContext *context;

@end

@implementation QSBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setupConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupConfig {
    _context = [[QSCurveContext alloc] init];
}

@end
