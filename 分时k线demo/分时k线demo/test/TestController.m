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

@interface TestController () {
    NSArray *gArr;
    NSMutableArray *gMArr;
}
@property (nonatomic, copy) NSMutableArray *datas;
@property (nonatomic, strong) MTDataManager *dataManager;

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataManager = [MTDataManager objectWithArray:[self getTestArray]];
    MTKlineView *kLineView = [[MTKlineView alloc] initWithFrame:CGRectMake(0, 100, 414, 500)];
    kLineView.manager = self.dataManager;
    [self.view addSubview:kLineView];
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
        
        NSString *time = [NSString stringWithFormat:@"%d", (arc4random() % 1000) + 1];
        NSArray *arr = [NSArray arrayWithObjects:time, open,high,low, close, nil];
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
