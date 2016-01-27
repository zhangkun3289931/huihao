//
//  ZKJinQiViewCell.h
//  huihao
//
//  Created by Alex on 15/9/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKJinQiModel.h"
@interface ZKJinQiViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong,nonatomic) ZKJinQiModel *jinQiModel;
@end
