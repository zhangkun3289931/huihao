//
//  ZKRoundButton.m
//  huihao
//
//  Created by 张坤 on 16/1/14.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKRoundButton.h"

@implementation ZKRoundButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.layer.cornerRadius=self.height *0.5;
    self.layer.masksToBounds=YES;
}

@end
