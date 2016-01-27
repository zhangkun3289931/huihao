//
//  ZKSlefMessageViewCell.m
//  huihao
//
//  Created by 张坤 on 15/12/7.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSlefMessageViewCell.h"
@interface ZKSlefMessageViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end
@implementation ZKSlefMessageViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
