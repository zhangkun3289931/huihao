//
//  ZKSearchTableViewCell.m
//  huihao
//
//  Created by 张坤 on 16/1/12.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKSearchTableViewCell.h"

@interface ZKSearchTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *orderByText;


@end

@implementation ZKSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView;
{
    //可充用标识符
    static NSString *ID=@"searchHotCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"ZKSearchTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
    ZKSearchTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:ID];
    cell.backgroundColor = [UIColor clearColor];
    // 点击cell的时候不要变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setOrderByStr:(NSString *)orderByStr
{
    _orderByStr =orderByStr;
    
    self.orderByText.text = orderByStr;
    
}
@end
