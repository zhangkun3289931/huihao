//
//  UIBarButtonItem+ZKExtaion.h
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZKExtaion)
+ (instancetype)itemWithAction:(SEL)action target:(id)target imageName :(NSString *)imageName selectImageName:(NSString *)selectImageName;
+ (instancetype)itemWithAction:(SEL)action target:(id)target imageText:(NSString *)title imageName :(NSString *)imageName selectImageName:(NSString *)selectImageName;
@end
