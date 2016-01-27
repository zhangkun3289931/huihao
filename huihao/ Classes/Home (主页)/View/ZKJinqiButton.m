//
//  ZKJinqiButton.m
//  huihao
//
//  Created by Alex on 15/9/28.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKJinqiButton.h"

@implementation ZKJinqiButton
- (void)setup{
    [self setAdjustsImageWhenHighlighted:NO];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    [self setBackgroundImage:[UIImage imageNamed:@"tongyong_botton_hui"] forState:UIControlStateSelected];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = 120;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
