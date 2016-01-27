//
//  ZKCommonTools.h
//  huihao
//
//  Created by 张坤 on 15/10/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum
{
    StateTypeSuccess=0,
    StateTypeNoLogin=-106
}StateType;
@interface ZKCommonTools : NSObject
+ (BOOL)JudgeState:(NSDictionary *)json controller:(Class)controller;
+ (BOOL)JudgeState:(NSDictionary *)json;

+ (UIColor *)customColor;
@end
