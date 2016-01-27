//
//  ZKKeshiTableViewCell.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
@class ZKKeshiTableViewCell;
@protocol ZKKeshiTableViewCellDelegate <NSObject>
- (void) keShiTableViewCellWithClick:(ZKKeshiTableViewCell *)cell button:(UIButton *)button;
@end
@interface ZKKeshiTableViewCell : UITableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,weak) id<ZKKeshiTableViewCellDelegate> delegate;
@end
