//
//  QSBaseViewController.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/1/1.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCurveContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSBaseViewController : UIViewController

@property (nonatomic, strong, readonly) QSCurveContext *context;

@end

NS_ASSUME_NONNULL_END
