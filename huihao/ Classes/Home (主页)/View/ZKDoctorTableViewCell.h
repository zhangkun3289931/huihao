//
//  ZKDoctorTableViewCell.h
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKDoctorModel.h"
@class ZKDoctorTableViewCell;
@protocol ZKDoctorTableViewCellDelegate <NSObject>
- (void)doctorTableViewCellWithClick:(ZKDoctorTableViewCell *)cell button:(UIButton *)button;
@end
@interface ZKDoctorTableViewCell : UITableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@property (nonatomic,weak) id<ZKDoctorTableViewCellDelegate> delegate;
@end
