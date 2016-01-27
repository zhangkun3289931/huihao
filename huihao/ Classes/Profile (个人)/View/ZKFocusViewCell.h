//
//  ZKFocusViewCell.h
//  huihao
//
//  Created by Alex on 15/9/29.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKFocusModel.h"
@class ZKFocusViewCell;
@protocol ZKFocusViewCellDelegate <NSObject>

- (void)focusViewChlick:(ZKFocusViewCell *)cell andClick:(ZKFocusModel *)focusModel;

@end
@interface ZKFocusViewCell : UITableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView;
@property (nonatomic,weak) id<ZKFocusViewCellDelegate> delegate;
@property (nonatomic,strong) ZKFocusModel *focusModel;
@end
