
//
//  ZKRedioButton.m
//  huihao
//
//  Created by Alex on 15/10/8.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKRedioButton.h"
@interface ZKRedioButton()
@property (nonatomic,strong) UIImageView *label;
@end
@implementation ZKRedioButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        
        UIImageView *label = [[UIImageView alloc]init];
        self.label = label;
        label.contentMode = UIViewContentModeScaleAspectFit;
        [label setImage:[UIImage imageNamed:@"center_cancel"]];
        [self addSubview:label];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = CGRectMake(self.width-10, 0, 10, self.height);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.layer.cornerRadius=5;
    self.layer.masksToBounds=YES;
}

@end
