//
//  ZKUserTool.h
//  huihao
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKUserModdel.h"
@interface ZKUserTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(ZKUserModdel *)user;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (ZKUserModdel *)user;

+ (BOOL)deleteAccount;

+ (void)judgeIsLogin;
@end
