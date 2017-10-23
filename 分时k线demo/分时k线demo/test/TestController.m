//
//  TestController.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/8/30.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "TestController.h"
#import "MTModel.h"
#import "BaseTest.h"
#import "Test1.h"
#import "Test2.h"
#import "MTDataManager.h"
#import "MTKlineView.h"
#import "MTFenShiView.h"

#import "MTTimeLineModel.h"

@interface TestController () {
    NSArray *gArr;
    NSMutableArray *gMArr;
}
@property (nonatomic, copy) NSMutableArray *datas;
@property (nonatomic, strong) MTDataManager *dataManager;
@property (nonatomic, strong) MTKlineView *kLineView;
@property (nonatomic, strong) MTFenShiView *fenShiView;

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataManager = [[MTDataManager alloc] initWithArray:[self getTestArray]];
    [self.view addSubview:self.fenShiView];
}

- (NSArray *)getTimeLineArray {
    NSMutableArray *timeLineModels = [[NSMutableArray alloc] init];
    for (int i = 0; i < 300; i++) {
        NSNumber *price = [NSNumber numberWithInt:(arc4random() % 100) + 1];
        CGFloat volume = (arc4random() % 100) + 1;
        NSString *date = @"10:30";
        MTTimeLineModel *model = [[MTTimeLineModel alloc] init];
        model.Price = price;
        model.AvgPrice = 80;
        model.Volume = volume;
        model.TimeDesc = date;
        [timeLineModels addObject:model];
    }
    
    return timeLineModels;
}

- (NSArray *)getTestArray {
    NSMutableArray *array = [NSMutableArray array];
    //伪造数据
    for (int i = 0; i < 300; i++) {
        int op = (arc4random() % 1000) + 1;
        int cl = (arc4random() % 1000) + 1;
        NSNumber *open = [NSNumber numberWithInt:op];
        NSNumber *close = [NSNumber numberWithInt:cl];
        
        NSNumber *high;
        if (op > cl) {
            int hi = op + arc4random() % 50;
            high = [NSNumber numberWithInt:hi];
            
        } else {
            int hi = cl + arc4random() % 50;
            high = [NSNumber numberWithInt:hi];
            
        }
        
        NSNumber *low;
        if (op > cl) {
            int lo = cl - arc4random() % 50;
            if (lo <= 0) {
                lo = 0;
            }
            
            low = [NSNumber numberWithInt:lo];
        } else {
            int lo = op - arc4random() % 50;
            if (lo <= 0) {
                lo = 0;
            }
            
            low = [NSNumber numberWithInt:lo];
        }
        NSNumber *volume = [NSNumber numberWithFloat:(arc4random() % 1000) + 1];
        
        NSString *time = [NSString stringWithFormat:@"%d", (arc4random() % 1000) + 1];
        NSArray *arr = [NSArray arrayWithObjects:time, open,high,low, close, volume, nil];
        [array addObject:arr];
    }
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BaseTest *)getTest:(NSInteger)index {
    BaseTest *test = nil;
    if (index == 1) {
        test = [[Test1 alloc] init];
    } else if (index == 2) {
        test = [[Test2 alloc] init];
    } else {
        test = [[BaseTest alloc] init];
    }
    
    return test;
}

#pragma mark -
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fenshi:(id)sender {
    if (self.kLineView.superview) {
        [self.kLineView removeFromSuperview];
    }
    if (!self.fenShiView.superview) {
        [self.view addSubview:self.fenShiView];
    }
    
    [self.fenShiView updateDrawTimeLine];
}

- (IBAction)dayKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
}

- (IBAction)weekKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
}
- (IBAction)monthKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
}

- (IBAction)yearKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
}

#pragma mark -
- (MTKlineView *)kLineView {
    if (!_kLineView) {
        _kLineView = [[MTKlineView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 350)];
        _kLineView.manager = self.dataManager;
    }
    
    return _kLineView;
}

- (MTFenShiView *)fenShiView {
    if (!_fenShiView) {
        _fenShiView = [[MTFenShiView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 350)];
        _fenShiView.timeLineModels = [self getTimeLineArray];
        [_fenShiView updateDrawTimeLine];
    }
    
    return _fenShiView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
