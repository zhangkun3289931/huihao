//
//  UIBarButtonItem+ZKExtaion.m
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "UIBarButtonItem+ZKExtaion.h"
#import "UIButton+ZKExtaion.h"
@implementation UIBarButtonItem (ZKExtaion)
+ (instancetype)itemWithAction:(SEL)action target:(id)target imageName :(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    UIButton *backBTN=[UIButton initWithButtonImage:imageName selectImage:selectImageName];
    [backBTN addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
}
+ (instancetype)itemWithAction:(SEL)action target:(id)target imageText:(NSString *)title imageName :(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    UIButton *backBTN=[UIButton initWithButtonImage:imageName selectImage:selectImageName];
    [backBTN setTitle:title forState:UIControlStateNormal];
    [backBTN addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:backBTN];
    
}
@end
