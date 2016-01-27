//
//  ZKTongyuQiangViewController.h
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
@interface ZKTongyuQiangViewController : UITableViewController
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@end
