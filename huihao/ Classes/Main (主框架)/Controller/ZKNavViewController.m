//
//  ZKNavViewController.m
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKNavViewController.h"
#import "UIButton+ZKExtaion.h"
#import "UIBarButtonItem+ZKExtaion.h"
#import "huihao.pch"
@implementation ZKNavViewController

+ (void)initialize
{
    //设置整个项目的UINavigationBar属性
    UINavigationBar *bar=  [UINavigationBar appearance];
    bar.tintColor=[UIColor whiteColor];//ZKColor(113, 128, 248);
    [bar setBackgroundImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]forBarMetrics:UIBarMetricsDefault];  //设置背景
    //bar.backgroundColor=TabBottomTextSelectColor;
    NSDictionary *dictBar=@{
                            NSForegroundColorAttributeName :[UIColor whiteColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                            };
    [bar setTitleTextAttributes:dictBar];
    

   
    //设置UIBarButtonItem整个项目的item 主题
    UIBarButtonItem *items=  [UIBarButtonItem appearance];
    //设置普通状态
    NSDictionary *dict=@{
                         NSForegroundColorAttributeName :[UIColor whiteColor],
                         NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                         };
    [items setTitleTextAttributes:dict forState:UIControlStateNormal];
    // 设置不可用状态
    NSDictionary *disableDict=@{
                         NSForegroundColorAttributeName :[UIColor lightGrayColor],
                         NSFontAttributeName:[UIFont systemFontOfSize:14.0f]
                         };
    [items setTitleTextAttributes:disableDict forState:UIControlStateDisabled];
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    // NSLog(@"%ld",self.childViewControllers.count);
    if (self.childViewControllers.count>0) {
        //隐藏tabbar、
        viewController.hidesBottomBarWhenPushed=YES;
        
        viewController.navigationItem.leftBarButtonItem.title=@"返回";
        //左边按钮
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithAction:@selector(back) target:self imageName:@"navigationbar_back_highlighted" selectImageName:@"navigationbar_back_highlighted"];
       // viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        //右边按钮
        viewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"回到主页" style:0 target:self action:@selector(moreBack)];
    }
    
    [super pushViewController:viewController animated:animated];
    
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)moreBack
{
    [self clearAction];
}
//清除历史纪录
- (void)clearAction
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要回到主页?"]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self popToRootViewControllerAnimated:YES];
    
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
