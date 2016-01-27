//
//  UIView+Extension.m
//  黑马微博2期
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (UIView *)showErrorView {
    CGFloat imageWH = 100;
    UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, imageWH*4)];
    UIImageView *imageView= [[UIImageView alloc]init];
    CGFloat dx= (self.width-imageWH) * 0.5;
    imageView.frame=CGRectMake(dx, dx, imageWH, imageWH);
    [imageView setImage:[UIImage imageNamed:@"error_image"]];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    UILabel *label=  [[UILabel alloc]init];
    label.frame=CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10,  self.width, 20);
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = HuihaoBingTextColor;
    label.textAlignment=NSTextAlignmentCenter;
    label.text=LoaderString(@"upNODataText");
    
    [footView addSubview:imageView];
    [footView addSubview:label];
    
    return footView;

}

@end
