//
//  ZKFocusHeaderView.m
//  huihao
//
//  Created by 张坤 on 15/10/15.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKFocusHeaderView.h"
#import "huihao.pch"
@interface ZKFocusHeaderView()
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *headTextView;
@property (nonatomic,strong) UIButton *headAccessView;
@end
@implementation ZKFocusHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *headView=[[UIView alloc]init];
        CGFloat W= [UIScreen mainScreen].bounds.size.width;
        headView.frame=CGRectMake(0, 0, W, 30);
        headView.backgroundColor=[UIColor whiteColor];
        [self addSubview:headView];
        self.headView=headView;
        
        UIImageView *headImageView=[[UIImageView alloc]init];
        headImageView.frame=CGRectMake(10, 5,20, 20);
        headImageView.contentMode=UIViewContentModeScaleAspectFit;
        [headView addSubview:headImageView];
        self.headImageView=headImageView;
        
        UILabel *headTextView=[[UILabel alloc]init];
        headTextView.frame=CGRectMake(35, 0, W, 30);
        headTextView.font=[UIFont systemFontOfSize:14];
        headTextView.textAlignment=NSTextAlignmentLeft;
         [headView addSubview:headTextView];
        self.headTextView=headTextView;
        
        UIButton *headAccessView=[UIButton buttonWithType:UIButtonTypeCustom];
        headAccessView.frame=CGRectMake(W-30, 0, 20, 30);
        headAccessView.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
        [headAccessView setImage:[UIImage imageNamed:@"check_info_down"] forState:UIControlStateNormal];

        [headAccessView addTarget:self action:@selector(checkUD:) forControlEvents:UIControlEventTouchDown];
        [headView addSubview:headAccessView];
        self.headAccessView=headAccessView;
    }
    return self;
}
- (void)setGroupModel:(ZKGroupModel *)groupModel
{
    _groupModel=groupModel;
    self.headTextView.text=groupModel.name;
    NSLog(@"%@",groupModel.imgName);
    [self.headImageView setImage:groupModel.imgName];
  
}
- (void)checkUD:(UIButton *)button
{
   // button.selected=!button.isSelected;
    self.groupModel.opened = !self.groupModel.isOpened;
   [self.delegate regionController:self buttonType:button.selected];
}
- (void)didMoveToSuperview
{
    if (!self.groupModel.opened) {
         self.headAccessView.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
         self.headAccessView.transform = CGAffineTransformMakeRotation(0);
    }
}

@end
