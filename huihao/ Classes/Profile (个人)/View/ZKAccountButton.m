//
//  ZKAccountButton.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKAccountButton.h"

@implementation ZKAccountButton
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    // NSLog(@"-%@",NSStringFromCGRect(contentRect));
    CGFloat titleW=100;
    CGFloat titleH=25;
    CGFloat x=(contentRect.size.width)*0.5;
    CGFloat y=(contentRect.size.height-titleH)*0.8;
    
    return CGRectMake(x, y, titleW,  titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=50;
    CGFloat x=(contentRect.size.width-imageW)*0.5+10;
    CGFloat y=(contentRect.size.height-imageW)*0.1;
    return CGRectMake(x,y , 38, 35);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
