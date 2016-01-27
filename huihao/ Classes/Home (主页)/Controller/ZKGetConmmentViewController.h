//
//  ZKGetConmmentViewController.h
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
#import "ZKDocterMenZhenViewController.h"
#import "ZKDoctorZhuYuanViewController.h"
@interface ZKGetConmmentViewController : UIViewController
@property (nonatomic,assign) NSInteger isKeshi;

@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@end
