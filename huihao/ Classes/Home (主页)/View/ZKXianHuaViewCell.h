//
//  ZKXianHuaViewCell.h
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKXinhuaModel.h"



@interface ZKXianHuaViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKXinhuaModel *xinhuaModel;
@end
