//
//  ZKRegisterViewController.h
//  huihao
//
//  Created by Alex on 15/9/15.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKRegisterViewController;
@protocol ZKRegisterViewControllerDelegate <NSObject>
- (void) registerViewController:(ZKRegisterViewController *)vc;
@end

@interface ZKRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak,nonatomic) id<ZKRegisterViewControllerDelegate> delegate;
@end
