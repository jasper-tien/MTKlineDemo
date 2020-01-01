//
//  QSMainShareTimeView.m
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import "QSMainShareTimeView.h"
#import "QSTrendShareTimeVM.h"

@interface QSMainShareTimeView ()
@property (nonatomic, strong) QSTrendShareTimeVM *viewModel;
@end

@implementation QSMainShareTimeView

- (instancetype)initWithViewModel:(QSTrendShareTimeVM *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(QSTrendShareTimeVM *)viewModel {
    if (self = [super initWithFrame:frame]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)bindVM:(QSTrendShareTimeVM *)viewModel {
    self.viewModel = viewModel;
}

@end
