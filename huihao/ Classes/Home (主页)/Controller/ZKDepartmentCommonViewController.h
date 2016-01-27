//
//  ZKCommonTableViewController.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
#import "ZKDepartmentCommonViewController.h"

@interface ZKDepartmentCommonViewController : UITableViewController

@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@end
