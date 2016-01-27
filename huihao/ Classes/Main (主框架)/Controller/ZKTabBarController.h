//
//  ZKTabBarController.h
//
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//
/**
 *  1. 把UITaBar内部的控制器封装起来，不让外界了解
    2. 每一段代码都应该呆着它最合适的位置
    3. 重复代码的抽取思路：
        1》一样的抽取，放在同一个方法中，
        2》不一样的变成参数，
        3》调用方法传递参数
    4. //hidesBottomBarWhenPushed :当test1 被push的时候，test1所在的tabbar会自动隐藏；  当test1被pop出来的时候， test1所在的tabbar会显示出来。
        test1.hidesBottomBarWhenPushed=YES;
    5. 
 */
#import <UIKit/UIKit.h>
#import "ZKHomeViewController.h"
#import "ZKProfileViewController.h"
@interface ZKTabBarController : UITabBarController

@end
