//
//  ZKRectImage.m
//  huihao
//
//  Created by 张坤 on 15/10/14.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKRectImage.h"
#import "huihao.pch"
@implementation ZKRectImage
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setShadow];
         self.layer.borderWidth=ImageBorderWidth;
         self.layer.borderColor=[UIColor colorWithRed:0.600 green:0.827 blue:0.957 alpha:1.000].CGColor;
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setShadow];

}
- (void)setShadow
{
     self.layer.borderWidth=ImageBorderWidth;
     self.layer.borderColor=[UIColor colorWithRed:0.600 green:0.827 blue:0.957 alpha:1.000].CGColor;
    //    //添加四个边阴影
//    self.layer.shadowColor =  TabBottomTextSelectColor.CGColor;//阴影颜色
//    self.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    self.layer.shadowOpacity = 1.0;//不透明度
//    self.layer.shadowRadius = ImageBorderWidth;//半径
//    self.contentMode = UIViewContentModeScaleToFill;
}

@end
