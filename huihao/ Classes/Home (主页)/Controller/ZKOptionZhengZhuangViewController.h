//
//  ZKOptionZhengZhuangViewController.h
//  huihao
//
//  Created by 张坤 on 15/11/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
@class ZKOptionZhengZhuangViewController;
@protocol ZKOptionZhengZhuangViewControllerDelegate <NSObject>

- (void)optionZhengZhuangViewController:(ZKOptionZhengZhuangViewController *)switchI switchWithItem:(NSString *)str;

@end
@interface ZKOptionZhengZhuangViewController : UIViewController
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@property (nonatomic,strong) id<ZKOptionZhengZhuangViewControllerDelegate> delegate;
@end
