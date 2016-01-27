//
//  ZKCommonViewCell.h
//  huihao
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCommonBaseViewCell.h"

@class ZKCommonDepartmentViewCell;
@protocol ZKCommonViewCellDelegate <NSObject>
- (void) commonViewCellNoLogin:(ZKCommonDepartmentViewCell *)cell;
@optional
- (void) commonViewCellBingClick:(ZKCommonDepartmentViewCell *)cell withBingName :(NSString *)bingName;
@end
@interface ZKCommonDepartmentViewCell : ZKCommonBaseViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKCommentModel *commentModel;
@property (nonatomic,weak) id<ZKCommonViewCellDelegate> delegate;
@end
