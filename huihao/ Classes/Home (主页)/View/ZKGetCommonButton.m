//
//  ZKGetCommonButton.m
//  huihao
//
//  Created by 张坤 on 15/10/12.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKGetCommonButton.h"
#import "UIView+Extension.h"
#import "huihao.pch"
@implementation ZKGetCommonButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        [self setTitleColor:HuihaoRedBG forState:UIControlStateSelected];
         [self setTitleColor:TabBottomTextSelectColor forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"comment_selectde"] forState:UIControlStateSelected];
    }
    return self;
}

#define buttonMargin  ((self.height-self.imageView.height-self.titleLabel.height)/3)
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageW=self.imageView.width;
    CGFloat imageH=self.imageView.height;
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
