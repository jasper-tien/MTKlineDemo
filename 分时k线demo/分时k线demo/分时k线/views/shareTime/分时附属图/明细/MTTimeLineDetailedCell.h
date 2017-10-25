//
//  MTTimeLineDetailedCell.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/25.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTimeLineDetailedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end
