

//
//  ZKTabBarController.m
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKTabBarController.h"
#import "ZKNavViewController.h"
//#import "ZKComposeViewController.h"
#import "ZKTabBar.h"
#import "ZKSearchQuestionViewController.h"
@interface ZKTabBarController () 

@end

@implementation ZKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabbar背景颜色
    //self.tabBar.barTintColor=[UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]];

    //1.实例化控制器
    ZKHomeViewController *home=[[ZKHomeViewController alloc]init];
    [self addChildVC:home Background:[UIColor whiteColor] title:@"医院评价" imageName:@"bottom_hos" selectImageName:@"bottom_hos_white"];
    
    ZKSearchQuestionViewController *discover=[[ZKSearchQuestionViewController alloc]init];
    [self addChildVC:discover Background:[UIColor whiteColor] title:@"你问我答" imageName:@"bottom_ask" selectImageName:@"bottom_ask_white"];
    
    ZKProfileViewController *profile=[[ZKProfileViewController alloc]init];
    [self addChildVC:profile Background:[UIColor whiteColor] title:@"个人中心" imageName:@"bottom_cen" selectImageName:@"bottom_cen_white"];

    [self setupUnreadCount];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return     UIStatusBarStyleLightContent;
}

/**
 *  添加子子控制器
 *
 *  @param vc              控制器
 *  @param Color           控制器背景颜色
 *  @param title           标题
 *  @param imageName       默认显示的图片名字
 *  @param selectImageName 选中显示的图片名字
 */
- (void)addChildVC:(UIViewController *)vc Background:(UIColor *)Color title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    vc.title=title;
    //如果直接复制，tabbar会渲染成灰色
    //UIImageRenderingModeAlwaysOriginal 告诉图片不要渲染
    vc.tabBarItem.image=[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //如果直接复制，tabbar会渲染成蓝色
    //UIImageRenderingModeAlwaysOriginal 告诉图片不要渲染
    vc.tabBarItem.selectedImage=[[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSDictionary *dict=@{
                         NSForegroundColorAttributeName:TabBottomTextColor,
                         NSFontAttributeName:[UIFont systemFontOfSize:12.0f]
                         };
    [vc.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    NSDictionary *dictS=@{
                          NSForegroundColorAttributeName:TabBottomTextSelectColor,
                          NSFontAttributeName:[UIFont systemFontOfSize:12.0f]
                          };
    [vc.tabBarItem setTitleTextAttributes:dictS forState:UIControlStateSelected];
    //将传进来的vc包装成nav。
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}
/**
 *  3. 获得未读数
 */
- (void)setupUnreadCount
{
    
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==NULL) {
        return;
    }
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId
                           };
    [MBProgressHUD showMessage: LoaderString(@"httpLoadText")];
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
                 self.childViewControllers.lastObject.tabBarItem.badgeValue = nil;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            } else { // 非0情况
                 self.childViewControllers.lastObject.tabBarItem.badgeValue = status;
                [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
