//
//  UIWindow+ZKExtension.m
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "UIWindow+ZKExtension.h"
#import "ZKTabBarController.h"
#import "ZKNewFeatureController.h"
@implementation UIWindow (ZKExtension)
- (void)switchRootViewController
{
    ZKTabBarController *tc=[[ZKTabBarController alloc]init];
    ZKNewFeatureController *newFeatureVC=[[ZKNewFeatureController alloc]init];
    //c存储沙盒中的版本号
    NSString *lastVersionStr= [[NSUserDefaults standardUserDefaults] objectForKey:@"versionStr"];
    //获取当前的版本号
    NSString *versionStr=[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //UIWindow *window=[UIApplication sharedApplication].keyWindow;
    if (![lastVersionStr isEqualToString:versionStr]) {
        //3. 将tc设置成 window的根控制器
        self.rootViewController=newFeatureVC;
        //将版本号存在沙盒
        [[NSUserDefaults standardUserDefaults] setObject:versionStr forKey:@"versionStr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        self.rootViewController=tc;
    }
}
@end
