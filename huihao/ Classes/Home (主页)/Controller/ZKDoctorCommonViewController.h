//
//  ZKDoctorCommonViewController.h
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCommonBaseViewController.h"
#import "ZKDoctorModel.h"
@interface ZKDoctorCommonViewController : UITableViewController
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@end
