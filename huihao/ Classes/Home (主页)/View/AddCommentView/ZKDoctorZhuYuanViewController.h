//
//  ZKDoctorZhuYuanViewController.h
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKDoctorModel.h"
#import "ZKKeShiModel.h"
#import "ZKCommonSuccessController.h"
#import "ZKSendXianHuaControllerViewController.h"
@interface ZKDoctorZhuYuanViewController : UIViewController
@property (strong, nonatomic)  ZKDoctorModel *doctorModel;
@property (strong, nonatomic)  ZKKeShiModel *keshiModel;
@end
