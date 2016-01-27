//
//  ZKhongbaoViewCell.h
//  huihao
//
//  Created by Alex on 15/9/30.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKHongBaoModel.h"
@interface ZKhongbaoViewCell : UITableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKHongBaoModel *hongbaoModel;
@end
