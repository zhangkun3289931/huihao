
//
//  ZKRedioView.m
//  huihao
//
//  Created by 张坤 on 15/11/4.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKRedioView.h"
#import "huihao.pch"
@implementation ZKRedioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor =BorderColor.CGColor;
        self.layer.borderWidth =1.0;
        self.layer.cornerRadius =5.0;
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
  //  self.layer.borderColor = BorderColor.CGColor;
  //  self.layer.borderWidth =1.0;
    self.layer.cornerRadius =5.0;
}


@end
