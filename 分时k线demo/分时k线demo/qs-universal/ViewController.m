//
//  ViewController.m
//  分时k线demo
//
//  Created by tianmaotao on 2017/8/30.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import "ViewController.h"
#import "TestController.h"
#import "QSTrendMainVC.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fenKLineAction:(id)sender {
//    NSLog(@"分时k线");
//    TestController *vc = [[TestController alloc] init];
    Class cls = NSClassFromString(@"TestController");
    TestController *vc = (TestController *)[[cls alloc] init];
    [self presentViewController:vc animated:YES completion:nil];

}

- (IBAction)testAction:(id)sender {
//    TestController *vc = [[TestController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];

    QSTrendMainVC *vc = [[QSTrendMainVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch {
    if( pinch.numberOfTouches == 2 ) {
        CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
        CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
        CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
        NSLog(@"centerPoint.x:%f contentOffset.x:%f", centerPoint.x, self.scrollView.contentOffset.x);
    }
}

- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        //        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.bounces = NO;
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 300, 40)];
        _label.backgroundColor = [UIColor lightGrayColor];
        _label.textColor = [UIColor blackColor];
        [self.view addSubview:_label];
    }
    
    return _label;
}

@end
