//
//  ZKOrderDetialViewController.h
//  huihao
//
//  Created by Alex on 15/9/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKDoctorModel.h"
#import "ZKXinhuaModel.h"
#import "ZKJinqiDetialModel.h"
#import "ZKKeShiModel.h"
typedef enum{
    ZKPayTypeXianhua=0,
    ZKPayTypeJinQi
} ZKPayType;


@interface ZKOrderDetialViewController : UIViewController
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKXinhuaModel *xianhuaModel;
@property (nonatomic,strong) ZKJinqiDetialModel *detialModel;
@end
