


//
//  ZKInfoButton.m
//  huihao
//
//  Created by 张坤 on 15/10/14.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKInfoButton.h"
#import "huihao.pch"

@implementation ZKInfoButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=15;

        self.layer.masksToBounds=YES;
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=20;
    CGFloat x=0;
    CGFloat y=(contentRect.size.height-imageW)/2;
    return CGRectMake(x, y, imageW, imageW);
}
#define buttonMargin  ((self.height-self.imageView.height-self.titleLabel.height)/3)
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageW=self.imageView.width;
   // CGFloat imageH=self.imageView.height;
    self.imageView.x=5;
    self.imageView.y=(self.imageView.size.height-imageW)/2+5;
    
    self.titleLabel.x=imageW+10;
    self.titleLabel.y=(self.imageView.size.height-imageW)/2+7;
    self.titleLabel.width=self.width;
    //self.titleLabel.backgroundColor=[UIColor redColor];
}

@end
