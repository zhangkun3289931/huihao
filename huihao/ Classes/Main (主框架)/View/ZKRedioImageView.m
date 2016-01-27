//
//  ZKRedioImageView.m
//  huihao
//
//  Created by 张坤 on 15/10/12.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKRedioImageView.h"
#import "UIView+Extension.h"

@implementation ZKRedioImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius=self.height*0.5;
        self.layer.masksToBounds=YES;
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius=self.height*0.5;;
    self.layer.masksToBounds=YES;
}

@end
