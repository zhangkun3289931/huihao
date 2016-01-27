//
//  ZKTopicTableViewCell.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTopicModel.h"
#define UIScerrenIconWH 40
#define UIScerrenSolveWH 40
#define UIScerrenHeight  self.view.bounds.size.height
#define UIScerrenWidth  self.view.bounds.size.width
#define TopicViewMargin 0
#define TopicMargin 5
#define TopNameFont [UIFont systemFontOfSize:12]
#define TopContentFont [UIFont systemFontOfSize:12]
#define TopTimeFont [UIFont systemFontOfSize:10]
@interface ZKTopicTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 是否解决*/
@property (nonatomic,strong) UIImageView *isSeloveIV;
@property (nonatomic,strong) UIButton *userMoreBT;
@property (nonatomic,strong) ZKTopicModel *topic;

@end
