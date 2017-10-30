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

@interface TestController ()<MTKlineViewDataSource> {
    NSArray *gArr;
    NSMutableArray *gMArr;
    NSInteger timerCount;
}
@property (nonatomic, copy) NSMutableArray *datas;
@property (nonatomic, strong) MTDataManager *dataManager;
@property (nonatomic, strong) MTKlineView *kLineView;
@property (nonatomic, strong) MTFenShiView *fenShiView;
@property (nonatomic, strong) NSTimer *fenshiTimer;

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    timerCount = 0;
    [self.view addSubview:self.fenShiView];
    [self.kLineView updateDataWithKlineType:SJKlineType_Day];
}

- (NSArray *)getTimeLineArray {
    NSMutableArray *timeLineModels = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        NSNumber *price;
        CGFloat volume = 0;
        if (i < 20) {
            price = [NSNumber numberWithInt:(arc4random() % 10) + 60];
            volume = (arc4random() % 60) + 10;
        } else if (i > 20 && i < 60) {
            price = [NSNumber numberWithInt:(arc4random() % 10) + 20];
            volume = arc4random() % 10 + 20;
        }else {
            price = [NSNumber numberWithInt:(arc4random() % 10) +10];
            volume = (arc4random() % 10) +10;
        }
        NSString *date = @"10:30";
        MTTimeLineModel *model = [[MTTimeLineModel alloc] init];
        model.Price = price;
        model.previousClosePrice = 50;
        model.Volume = volume;
        model.TimeDesc = date;
        [timeLineModels addObject:model];
    }
    
    return timeLineModels;
}

- (NSArray *)getTestArray {
    NSMutableArray *array = [NSMutableArray array];
    //伪造数据
    for (int i = 0; i < 400; i++) {
        int op = (arc4random() % 1000) + 50;
        int cl = (arc4random() % 1000) + 50;
        NSNumber *high;
        NSNumber *low;
        if (ABS(cl - op) > 300) {
            if (cl > op) {
                cl = op + arc4random() % 300;
                
                int hi = cl + arc4random() % 50;
                high = [NSNumber numberWithInt:hi];
                
                int lo = op - arc4random() % 50;
                if (lo <= 0) {
                    lo = 0;
                }
                low = [NSNumber numberWithInt:lo];
                
            }else {
                op = cl + arc4random() % 300;
                
                int hi = op + arc4random() % 50;
                high = [NSNumber numberWithInt:hi];
                
                int lo = cl - arc4random() % 50;
                if (lo <= 0) {
                    lo = 0;
                }
                low = [NSNumber numberWithInt:lo];
            }
        }
        
        NSNumber *open = [NSNumber numberWithInt:op];
        NSNumber *close = [NSNumber numberWithInt:cl];
        
        
        NSNumber *volume = [NSNumber numberWithFloat:(arc4random() % 100) + 500];
        
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
    [self.kLineView updateDataWithKlineType:SJKlineType_Day];
}

- (IBAction)weekKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
    [self.kLineView updateDataWithKlineType:SJKlineType_Day];
}
- (IBAction)monthKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
    [self.kLineView updateDataWithKlineType:SJKlineType_Day];
}

- (IBAction)yearKline:(id)sender {
    if (self.fenShiView.superview) {
        [self.fenShiView removeFromSuperview];
    }
    if (!self.kLineView.superview) {
        [self.view addSubview:self.kLineView];
    }
    [self.kLineView updateDataWithKlineType:SJKlineType_Day];
}

#pragma mark - MTKlineViewDataSource
- (MTDataManager *)kLineViewDataManager {
    return [[MTDataManager alloc] initWithArray:[self getTestArray]];
}

#pragma mark -
- (MTKlineView *)kLineView {
    if (!_kLineView) {
        _kLineView = [[MTKlineView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 350)];
        _kLineView.dataSource = self;
    }
    
    return _kLineView;
}

- (MTFenShiView *)fenShiView {
    if (!_fenShiView) {
        _fenShiView = [[MTFenShiView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 350)];
        _fenShiView.timeLineModels = [self getTimeLineArray];
        [_fenShiView updateDrawTimeLine];
        self.fenshiTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    return _fenShiView;
}

- (void)timerAction {
    timerCount++;
    if (timerCount >= 135) {
        [self.fenshiTimer invalidate];
        self.fenshiTimer = nil;
    }
    
    NSNumber *price = [NSNumber numberWithInt:(arc4random() % 10) +10];
    CGFloat volume = (arc4random() % 10) +10;
    NSString *date = @"10:30";
    MTTimeLineModel *model = [[MTTimeLineModel alloc] init];
    model.Price = price;
    model.previousClosePrice = 50;
    model.Volume = volume;
    model.TimeDesc = date;
    [_fenShiView updateDrawTimeLineWithNewTimeLineModel:model isSameTime:NO];
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
