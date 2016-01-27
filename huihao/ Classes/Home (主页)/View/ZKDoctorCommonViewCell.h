//
//  ZKDoctorCommonViewCell.h
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCommonBaseViewCell.h"
@class ZKDoctorCommonViewCell;
@protocol ZKDoctorCommonViewCellDelegate <NSObject>
- (void) doctorViewCellNoLogin:(ZKDoctorCommonViewCell *)cell;
@optional
- (void) doctorViewCellWithBingClick:(ZKDoctorCommonViewCell *)cell bingName:(NSString *)bingName;
@end

@interface ZKDoctorCommonViewCell : ZKCommonBaseViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZKDoctorCommonModel *commentModel;
@property (nonatomic,weak) id<ZKDoctorCommonViewCellDelegate> delegate;
@end
