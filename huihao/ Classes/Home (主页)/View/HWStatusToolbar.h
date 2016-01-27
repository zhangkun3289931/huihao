//
//  HWStatusToolbar.h
//  黑马微博2期
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKZhengZhuangModel.h"
@class HWStatusToolbar;
@protocol HWStatusToolbarDelegate <NSObject>
- (void)toolBar:(HWStatusToolbar *)toolBar clickButton:(UIButton *)button;
@end
@interface HWStatusToolbar : UIView

+ (instancetype)toolbar;
@property (nonatomic,strong) NSArray *models;
@property (nonatomic,weak) id<HWStatusToolbarDelegate> dalegate;
@end
