//
//  ZKSitchBingControllerTableViewController.h
//  huihao
//
//  Created by Alex on 15/9/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKBingModel.h"
#import "ZKFileReadWriteTool.h"
#import "MJExtension.h"
#import "ZKBingModel.h"
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
@class ZKSitchBingController;
@protocol ZKSitchBingControllerTableViewControllerDelegate <NSObject>

- (void)switchItem:(ZKSitchBingController *)switchI switchWithItem:(ZKBingModel *)bingMoel;

@end
@interface ZKSitchBingController : UITableViewController
@property (nonatomic,weak) id<ZKSitchBingControllerTableViewControllerDelegate> delegate;
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@end
