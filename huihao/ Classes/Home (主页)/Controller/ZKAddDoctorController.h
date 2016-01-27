//
//  ZKAddDoctorController.h
//  huihao
//
//  Created by Alex on 15/10/9.
//  Copyright © 2015年 张坤. All rights reserved.

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
@interface ZKAddDoctorController : UITableViewController
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@end
