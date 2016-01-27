//
//  ZKNavViewController.h
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//
/**
 *  统一所有PUSH控制器的导航栏，左上角跟右上角的内容：
    拦截所有push 进来的控制器，
    重写push方法
    %90的拦截都是通过重写方法决定的
 */
#import <UIKit/UIKit.h>
typedef enum
{
    HongbaoType1=1,
     HongbaoType2=2,
     HongbaoType3=3,
     HongbaoType4=4,
}HongbaoType;
@interface ZKNavViewController : UINavigationController

@end
