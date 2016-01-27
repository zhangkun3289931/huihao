
//
//  ZKTabBar.m
//  微博
//
//  Created by 张坤 on 15/9/1.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKTabBar.h"
@interface ZKTabBar()
@property (nonatomic, weak) UIButton *plusButton;
@end
@implementation ZKTabBar
/**
 *  添加一个加号button
 */
- (void)AddPlusButton
{
    //添加一个按钮到tabbar上
    UIButton *plusButton=[[UIButton alloc]init];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    plusButton.size=plusButton.currentBackgroundImage.size;
    [self addSubview:plusButton];
    self.plusButton=plusButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self AddPlusButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置+号的位置
    self.plusButton.centerX=self.size.width*0.5;
    self.plusButton.centerY=self.size.height*0.5;
    
    //设置其他的tabbatButton
    CGFloat tabBarItemW=self.size.width/5;
    CGFloat tabBarItemIndex=0;
    for (UIView *child in self.subviews) {
        Class class=NSClassFromString(@"UITabBarButton");
        if (![child isKindOfClass:class]) continue;
        child.width=tabBarItemW;
        child.x=tabBarItemW*tabBarItemIndex;
        tabBarItemIndex++;
        if (tabBarItemIndex==2) tabBarItemIndex++;
    }
}

- (void)plusClick
{
    if ([self.delegate respondsToSelector:@selector(tabbarDidClickButton:)]) {
        [self.delegate tabbarDidClickButton:self];
    }
}
@end
