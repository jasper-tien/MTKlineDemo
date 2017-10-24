//
//  MTFiveRecordCell.h
//  分时k线demo
//
//  Created by tianmaotao on 2017/10/24.
//  Copyright © 2017年 tianmaotao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTFiveRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyOrSellLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end
