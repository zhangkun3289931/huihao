//
//  UIButton+ZKExtaion.m
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "UIButton+ZKExtaion.h"
@implementation UIButton (ZKExtaion)
+ (instancetype)initWithButtonImage:(NSString *)imageName selectImage:(NSString *)selectImageName
{
    UIButton *backBTN= [UIButton buttonWithType:UIButtonTypeCustom];
    [backBTN setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backBTN setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    // 写分类 优化代码。
    backBTN.size= backBTN.currentBackgroundImage.size;
    //[backBTN setFrame:CGRectMake(0, 0, size.width, size.height)];
    return backBTN;
    
}

- (instancetype)setRoundWithcornerRadius :(CGFloat)radius{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    return self;
}
- (instancetype)setBorderWithWidth :(CGFloat)borderWidth andBorderColor :(UIColor *)color{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
    return self;
}
- (instancetype)setRoundAndBorderWith :(CGFloat)radius BorderWidth: (CGFloat)borderWidth andBorderColor :(UIColor *)color {
    [self setRoundWithcornerRadius:radius];
    [self setBorderWithWidth:borderWidth andBorderColor:color];
    return self;
}
@end
