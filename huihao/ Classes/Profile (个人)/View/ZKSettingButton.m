//
//  ZKSettingButton.m
//  huihao
//
//  Created by 张坤 on 15/10/7.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSettingButton.h"
#import "UIView+Extension.h"
#import "huihao.pch"
@implementation ZKSettingButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
       // self.layer.cornerRadius=15;
       // self.layer.masksToBounds=YES;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        //self.backgroundColor=QianFenColor;
        
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=50;
    CGFloat x=(contentRect.size.width-imageW)*0.5;
    CGFloat y=(contentRect.size.height-imageW)*0.3;
    return CGRectMake(x,y , 50, 50);
}
#define buttonMargin  ((self.height-self.imageView.height-self.titleLabel.height)/3)
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageW=50;
    CGFloat imageH=50;
    self.imageView.x=(self.width-imageW)*0.5;
    self.imageView.y=buttonMargin;
   
    self.titleLabel.x=(self.width-self.titleLabel.width)*0.5;
    self.titleLabel.y=imageH+buttonMargin*2;
    //self.titleLabel.width=self.width;
    //self.titleLabel.backgroundColor=[UIColor redColor];
}
- (void)setHighlighted:(BOOL)highlighted
{

}
@end
