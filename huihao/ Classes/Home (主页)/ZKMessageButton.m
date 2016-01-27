//
//  ZKMessageButton.m
//  微博
//
//  Created by 张坤 on 15/9/15.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKMessageButton.h"
#import "UIImageView+WebCache.h"

@implementation ZKMessageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=15;
//        self.layer.shadowOffset = CGSizeMake(0, 10); //设置阴影的偏移量
//        self.layer.shadowRadius =10.0;  //设置阴影的半径
//        self.layer.shadowColor = [UIColor redColor].CGColor; //设置阴影的颜色为黑色
//        self.layer.shadowOpacity = 0.9; //设置阴影的不透明度
        self.layer.masksToBounds=YES;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
- (void)setModel:(ZKColumuModel *)model
{
    _model=model;
    [self setTitle:model.columnTitle forState:UIControlStateNormal];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self setImage:image forState:UIControlStateNormal];
    }];
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    // NSLog(@"-%@",NSStringFromCGRect(contentRect));
    CGFloat titleW=100;
    CGFloat titleH=25;
    CGFloat x=(contentRect.size.width-titleW)*0.5;
    CGFloat y=(contentRect.size.height-titleH)-10;
    
    return CGRectMake(x, y, titleW,  titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW=80;
    CGFloat x=(contentRect.size.width-imageW)*0.5;
    CGFloat y=(contentRect.size.height-imageW)*0.3;
    return CGRectMake(x,y , imageW, imageW);
}
@end
