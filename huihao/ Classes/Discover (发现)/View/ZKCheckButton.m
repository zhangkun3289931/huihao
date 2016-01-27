//
//  ZKCheckButton.m
//  huihao
//
//  Created by 张坤 on 15/11/9.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKCheckButton.h"

@implementation ZKCheckButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=15;
    CGFloat x=(contentRect.size.width-imageW)*0.5;
    CGFloat y=(contentRect.size.height-imageW)*0.3;
    return CGRectMake(x,y , imageW, imageW);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    // NSLog(@"-%@",NSStringFromCGRect(contentRect));
    CGFloat titleW=40;
    CGFloat titleH=15;
    //CGFloat x=(contentRect.size.width-titleW)*0.5;
    //CGFloat y=(contentRect.size.height-titleH)-10;
    
    return CGRectMake(46, 3, titleW,  titleH);
}
@end
