//
//  UIButton+ZKExtaion.h
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZKExtaion)
+ (instancetype)initWithButtonImage:(NSString *)imageName selectImage:(NSString *)selectImageName;

- (instancetype)setRoundWithcornerRadius :(CGFloat)radius;
- (instancetype)setBorderWithWidth :(CGFloat)borderWidth andBorderColor :(UIColor *)color;
@end
