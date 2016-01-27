//
//  ZKZhangDanViewCell.h
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKZhangDanModel.h"

@interface ZKZhangDanViewCell : UITableViewCell

+(instancetype)tagCellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKZhangDanModel *model;
@end
