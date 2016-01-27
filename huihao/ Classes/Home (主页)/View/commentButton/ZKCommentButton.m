
//
//  ZKCommentButton.m
//  huihao
//
//  Created by 张坤 on 15/10/3.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKCommentButton.h"
#import "huihao.pch"

@implementation ZKCommentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initUI];
}

- (void)initUI{
    self.adjustsImageWhenDisabled = NO;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font=[UIFont systemFontOfSize:13];
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]];;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 23, contentRect.size.width, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width-20)*0.5, 3,20,20);
    
}


@end
