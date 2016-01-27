//
//  ZKCommonCellButton.m
//  huihao
//
//  Created by 张坤 on 16/1/21.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKCommonCellButton.h"

@implementation ZKCommonCellButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = zkZhanFont;
        self.imageView.contentMode =
        UIViewContentModeScaleAspectFit;
        [self setImage:[UIImage imageNamed:@"eva_good"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"eva_good_full"] forState:UIControlStateDisabled];
        [self setTitleColor:HuihaoBingTextColor forState:UIControlStateNormal];
        [self setTitleColor:HuihaoBingTextColor forState:UIControlStateDisabled];
    }
    return self;
}

@end
