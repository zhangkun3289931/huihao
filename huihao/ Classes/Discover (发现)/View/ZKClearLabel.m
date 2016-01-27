//
//  ZKClearLabel.m
//  huihao
//
//  Created by 张坤 on 15/11/23.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKClearLabel.h"
@interface ZKClearLabel()
//@property (nonatomic,strong) UIButton *clearButton;
@end
@implementation ZKClearLabel
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
        clearButton.frame=CGRectMake(self.x, self.y, 20, 10);
        [clearButton addTarget:self action:@selector(closeImage:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:clearButton];
        NSLog(@"label=>%@",NSStringFromCGRect(self.frame));
        NSLog(@"button=>%@",NSStringFromCGRect(clearButton.frame));
        //self.clearButton=clearButton;
    }
    return self;
}
- (void)closeImage:(UIButton *)button
{
    //NSLog(@"%zd",button.tag);
    [self removeFromSuperview];
    [self.delegate clearLabel:self];
}
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
   // self.clearButton.tag=tag;
}
@end
