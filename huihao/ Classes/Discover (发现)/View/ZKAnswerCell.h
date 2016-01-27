//
//  ZKAnswerCell.h
//  huihao
//
//  Created by 张坤 on 15/12/1.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTopicTableViewCell.h"
@class ZKAnswerCell;
@protocol ZKAnswerCellDelegate <NSObject>

- (void)caiNaAnswer:(ZKAnswerCell *)answer withButton:(UIButton *)button;

- (void)answerCellNoLogin:(ZKAnswerCell *)cell;
@end

@interface ZKAnswerCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKTopicModel *topic;
@property (nonatomic,weak) id<ZKAnswerCellDelegate> delegate;
/** 采纳回复*/
@property (nonatomic,strong) UIButton *caiNaBtn;

@property (nonatomic,copy) NSString *articleUserId;
@end
