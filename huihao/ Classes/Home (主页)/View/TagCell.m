
//
//  TagCell.m
//  huihao
//
//  Created by 张坤 on 15/11/26.
//  Copyright © 2015年 张坤. All rights reserved.
//  yiny

#import "TagCell.h"

@interface TagCell()
@end

@implementation TagCell

-(void)awakeFromNib{
    [super awakeFromNib];
    //_viewBg.layer.cornerRadius = 10;
    
}


-(void)setTitleStr:(NSString *)title color:(NSString *)color{
    [self.text setText:title];
    self.viewBg.backgroundColor = [ZKCommonTools customColor];
}



@end
