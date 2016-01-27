//
//  ZKClearImageView.m
//  huihao
//
//  Created by 张坤 on 15/10/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKClearImageView.h"
#import "UIView+Extension.h"
@interface ZKClearImageView()
@property (nonatomic,strong) UIButton *clearButton;
@end
@implementation ZKClearImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //self.backgroundColor=[UIColor redColor];
        self.userInteractionEnabled=YES;
        NSString *closeStr=@"关闭";
        UIButton *clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setTitle:closeStr forState:UIControlStateNormal];
        [clearButton setTitleColor:HuihaoRedBG forState:UIControlStateNormal];
        clearButton.titleLabel.font=[UIFont systemFontOfSize:10];
        clearButton.frame=CGRectMake(self.width-30, 0, 30, 20);
        [clearButton addTarget:self action:@selector(closeImage:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:clearButton];
        self.clearButton=clearButton;
    }
    return self;
}
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.clearButton.tag=tag;
}

- (void)closeImage:(UIButton *)button
{
    //NSLog(@"%zd",button.tag);
    [self removeFromSuperview];
    [self.delegate clearImageView:self];
}
//- (void)setImage:(UIImage *)image
//{
//    [super setImage:image];
//    [self addSubview:self.clearButton];
//}
@end
