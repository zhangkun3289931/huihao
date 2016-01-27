//
//  UILabel+ZKAlertActionFont.m
//  huihao
//
//  Created by 张坤 on 16/1/26.
//  Copyright © 2016年 张坤. All rights reserved.
//


@interface UILabel (ZKAlertActionFont)
@end

@implementation UILabel (ZKAlertActionFont)
- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if (appearanceFont) {
        [self setFont:appearanceFont];
    }
}
- (UIFont *)appearanceFont
{
    return self.font;
}

@end
