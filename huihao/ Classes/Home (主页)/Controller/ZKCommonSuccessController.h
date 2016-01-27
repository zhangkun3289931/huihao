//
//  ZKCommonSuccessController.h
//  huihao
//
//  Created by Alex on 15/10/9.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
#import "ZKNavViewController.h"
@interface ZKCommonSuccessController : UIViewController
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@property (nonatomic,assign) HongbaoType hongbaoTy;
@property (nonatomic,assign) BOOL isKeshi;
@end
