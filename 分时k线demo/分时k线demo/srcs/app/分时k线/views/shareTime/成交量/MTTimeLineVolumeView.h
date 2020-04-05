//
//  MTTimeLineVolumeView.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/23.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MTTimeLineVolumeViewDelegate<NSObject>
/**
 *  长按
 */
- (void)timeLineVolumeViewLongPressExactPosition:(CGPoint)longPressPosition selectedIndex:(NSInteger)index longPressVolume:(CGFloat)volume;
@end

@class MTTimeLineModel;

@interface MTTimeLineVolumeView : UIView
@property (nonatomic, copy) NSArray<MTTimeLineModel *> *needDrawVolumeModels;
@property (nonatomic, weak) id<MTTimeLineVolumeViewDelegate> delegate;

- (void)updateDrawModels;

- (void)longPressOrMovingAtPoint:(CGPoint)longPressPosition;
@end
