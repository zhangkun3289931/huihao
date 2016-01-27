//
//  ZKSwitchTypeButton.m
//  huihao
//
//  Created by 张坤 on 16/1/13.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKSwitchTypeButton.h"

@implementation ZKSwitchTypeButton
#define marginTop 10

- (instancetype)initWithFrame:(CGRect)frame

{   self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self setTitleColor:HuihaoBingTextColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setRoundWithcornerRadius:(self.height - 10) * 0.5];

    }
    return self;
}


@end
