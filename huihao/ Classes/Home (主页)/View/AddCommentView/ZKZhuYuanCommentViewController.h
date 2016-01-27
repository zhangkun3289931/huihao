//
//  ZKZhuYuanCommentViewController.h
//  huihao
//
//  Created by Alex on 15/9/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKCommonSuccessController.h"
#import "ZKpennantsViewController.h"
@interface ZKZhuYuanCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (strong, nonatomic)  ZKKeShiModel *keshiModel;
@property (strong, nonatomic)  ZKDoctorModel *doctorModel;
@end
