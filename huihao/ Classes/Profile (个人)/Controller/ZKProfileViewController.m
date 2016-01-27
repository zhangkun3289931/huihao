//
//  ZKProfileViewController.m
//  huihao
//
//  Created by Alex on 15/9/15.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKProfileViewController.h"
#import "ZKLoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ZKHTTPTool.h"
#import "ZKSettingButton.h"
#import "ZKMyAccountMoneyController.h"
#import "ZKChangeIndoDAataViewController.h"
#import "ZKCustomSettingController.h"
#import "ZKFocusTableViewController.h"
#import "ZKUserTool.h"
#import "ZKSelfMessageViewController.h"
#import "ZKCollectionViewController.h"
#import "ZKSelfTopicViewController.h"

@interface ZKProfileViewController () <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *loginState;
@property (strong, nonatomic) IBOutlet UIButton *typeButton;
@property (strong, nonatomic) IBOutlet UIImageView *messsageBadgeIV;

@property (strong, nonatomic) IBOutlet UIButton *notificationBtn;

- (IBAction)notiButton:(UIButton *)sender;
- (IBAction)switchIconClick:(UIButton *)sender;

@end

@implementation ZKProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    //1. 初始化头像;
    [self setupHeadIcon];
    
    //2. 监听notafication的状态通知
    [ZKNotificationCenter addObserver:self selector:@selector(settingNotificationState) name:ZKCenterNotification object:nil];
    
    //3. 获得未读数
    [[NSRunLoop mainRunLoop] addTimer:[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES] forMode:NSRunLoopCommonModes]; // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    
    [self settingNotificationState];
}

- (void)settingNotificationState{
    self.notificationBtn.selected = [self isAllowedNotification];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //2.判断是否登录
    [ZKUserTool judgeIsLogin];
    
    [self setupHeadIcon];
}

/**
 *  获得未读数
 */
- (void)setupUnreadCount
{
    
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==NULL) {
        return;
    }
    
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getUnReadNum.do",baseUrl] params:params success:^(id json) {        // 微博的未读数
        //        int status = [responseObject[@"status"] intValue];
        // 设置提醒数字
        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
        NSLog(@"====%@",json);
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [json[@"status"] description];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
                self.tabBarItem.badgeValue = nil;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                self.messsageBadgeIV.hidden = YES;
            } else { // 非0情况
                self.tabBarItem.badgeValue = status;
                [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
                self.messsageBadgeIV.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  初始化头像;
 */
- (void)setupHeadIcon
{
    self.iconBtn.layer.cornerRadius = self.iconBtn.width*0.5;
    self.iconBtn.layer.borderWidth = 2;
    self.iconBtn.layer.borderColor = HuihaoRedBG.CGColor;
    self.iconBtn.layer.masksToBounds = YES;
    
    ZKUserModdel *user=[ZKUserTool user];
    if (user==nil) {
        self.loginState.text=@"未登录";
        [self.iconBtn setImage:[UIImage imageNamed:@"image_bg2"] forState:UIControlStateNormal];
    }else
    {
        NSString *name = user.nickName;
        if (name.length == 0) {
            name = user.username;
        }
        self.loginState.text = name;
        [self.iconBtn.imageView sd_setImageWithURL:[NSURL URLWithString:user.imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.iconBtn setImage:image forState:UIControlStateNormal];
        }];
    }    
}

/**
 *  判断app本地的通知是否打开
 *
 *  @return
 */
- (BOOL)isAllowedNotification {
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

- (void)openNotification
{
    // 1. 打开app的设置界面
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    // 2. 打开推送
    [self isOpen];
}
- (void)isOpen
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId,
                           @"isOpen":[NSString stringWithFormat:@"%zd",[self isAllowedNotification]]
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/operatePush.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];
}
- (IBAction)switchIconClick:(UIButton *)sender {
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==nil) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }
    
    ZKChangeIndoDAataViewController *changeIndoData=[[ZKChangeIndoDAataViewController alloc]init];
    changeIndoData.title=@"个人信息";
    [self.navigationController pushViewController:changeIndoData animated:YES];
    
}



- (IBAction)notiButton:(UIButton *)sender {
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==nil) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            [self openNotification];
            break;
        }
        case 1:
        {
            ZKFocusTableViewController *controller=[[ZKFocusTableViewController alloc]init];
            controller.title=@"我的关注";
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2:
        {
            ZKMyAccountMoneyController *controller=[[ZKMyAccountMoneyController alloc]init];
            controller.title=@"我的账户";
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 3:
        {
            ZKCustomSettingController *setting=[[ZKCustomSettingController alloc]init];
            setting.title=@"个人设置";
            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 4:
        {
            ZKSelfMessageViewController *setting=[[ZKSelfMessageViewController alloc]init];
            setting.title=@"我的消息";
            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 5:
        {
            ZKCollectionViewController *setting=[[ZKCollectionViewController alloc]init];
            setting.title=@"我的收藏";
            setting.isTopic=0;
            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 6:
        {
            ZKSelfTopicViewController *setting=[[ZKSelfTopicViewController alloc]init];
            setting.title=@"我的话题";
            //setting.isTopic=1;
            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 7:
        {
            [self showCallPhoneAlert];
            break;
        }
        default:
            break;
    }

}
- (void)showCallPhoneAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"拨打   10086" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
    }];
    
    [alert addAction:confirm];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancel];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}
@end
