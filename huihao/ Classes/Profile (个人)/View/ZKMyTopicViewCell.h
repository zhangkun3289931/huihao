//
//  ZKMyTopicViewCell.h
//  huihao
//
//  Created by 张坤 on 16/1/8.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTopicModel.h"

@interface ZKMyTopicViewCell : UITableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView;
@property (assign, nonatomic)  CGFloat cellHeight;
@property (strong, nonatomic)  ZKTopicModel *topicModel;
@end
