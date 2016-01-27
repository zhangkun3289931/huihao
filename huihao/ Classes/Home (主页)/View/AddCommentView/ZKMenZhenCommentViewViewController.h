//
//  ZKMenZhenCommentViewViewController.h
//  huihao
//
//  Created by Alex on 15/9/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKpennantsViewController.h"
#import "ZKBaseCommonViewController.h"
@interface ZKMenZhenCommentViewViewController : UIViewController
@property (strong, nonatomic)  NSString *mstr;
@property (strong, nonatomic)  ZKKeShiModel *keshiModel;
@property (strong, nonatomic)  ZKDoctorModel *doctorModel;
@end
