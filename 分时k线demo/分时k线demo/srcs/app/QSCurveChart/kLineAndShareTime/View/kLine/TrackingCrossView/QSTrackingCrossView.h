//
//  QSTrackingCrossView.h
//  分时k线demo
//
//  Created by tianmaotao on 2020/4/5.
//  Copyright © 2020 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSTrackingCrossView : UIView

@property (nonatomic, assign) CGPoint crossPoint;
@property (nonatomic, assign) CGRect dateRect;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, assign) CGFloat showValue;

- (instancetype)initWithFrame:(CGRect)frame crossPoint:(CGPoint)crossPoint dateRect:(CGRect)dateRect;

- (void)updateTrackingCrossView;

@end

NS_ASSUME_NONNULL_END
