//
//  ZKSearchBar.m
//  微博
//
//  Created by 张坤 on 15/9/1.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKSearchBar.h"

@implementation ZKSearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.background=[UIImage imageNamed:@"searchbar_textfield_background"];
        self.placeholder=@"请输入搜索条件？";
        [self setFont:[UIFont systemFontOfSize:13]];
        
        UIImageView *barImage=[[UIImageView alloc]init];
        [barImage setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        barImage.width=30;
        barImage.height=30;
        
        //设置图片的显示模式
        barImage.contentMode=UIViewContentModeCenter;
        self.leftView=barImage;
        //设置左边图片的显示模式
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    return self;
}


+ (instancetype)searchBar
{
    return [[self alloc]init];
}
@end
