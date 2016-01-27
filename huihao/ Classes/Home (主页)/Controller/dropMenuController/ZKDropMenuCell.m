
//
//  ZKDropMenuCell.m
//  huihao
//
//  Created by 张坤 on 15/10/14.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDropMenuCell.h"
#import "huihao.pch"
@interface ZKDropMenuCell()



@end
@implementation ZKDropMenuCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"dropMenuCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"ZKDropMenuCell" bundle:nil] forCellReuseIdentifier:ID];
    
    ZKDropMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];

    return cell;
}

- (void)setTitle:(NSString *)title
{
    _title=title;

    self.menuItemName.text=title;
  
}
@end
