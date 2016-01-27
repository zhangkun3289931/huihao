
//
//  ZKRedioLabel.m
//  huihao
//
//  Created by 张坤 on 15/10/14.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKRedioLabel.h"
#import "UIView+Extension.h"
@implementation ZKRedioLabel
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.font=zkContentFont;
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.numberOfLines=0;
        self.layer.cornerRadius=18 *0.5;
        self.layer.masksToBounds=YES;
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor=[UIColor whiteColor];
    self.font=zkContentFont;
    self.numberOfLines=0;
    self.layer.cornerRadius=18 *0.5;
    self.layer.masksToBounds=YES;
}
@end
