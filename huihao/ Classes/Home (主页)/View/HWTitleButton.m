//
//  HWTitleButton.m
//  黑马微博2期
//
//  Created by apple on 14-10-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWTitleButton.h"

#define HWMargin 2

@implementation HWTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAdjustsImageWhenHighlighted:NO];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setTitleColor:TabBottomTextSelectColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"shouyetiaoxianicon"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"shouyetiaoxianicofanzhuann"] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"shouye_shaixuan_center_normal_bg"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"] forState:UIControlStateSelected];
     
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = 0;
    self.titleLabel.y = 0;
    self.titleLabel.width = self.width - self.imageView.width - 5;
    self.titleLabel.height = self.height;
    
    self.imageView.x = self.titleLabel.width;
    self.imageView.y = 0;
    self.imageView.width = self.imageView.width;
    self.imageView.height = self.height;
}

@end
