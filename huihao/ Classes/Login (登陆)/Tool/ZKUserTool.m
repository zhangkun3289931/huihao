//
//  ZKUserTool.m
//  huihao
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKUserTool.h"
// 账号的存储路径
#define ZKUserModdelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.archive"]
@implementation ZKUserTool
+ (void)saveAccount:(ZKUserModdel *)user
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:user toFile:ZKUserModdelPath];
}

+ (ZKUserModdel *)user
{
    // 加载模型
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ZKUserModdelPath];
}
+ (BOOL)deleteAccount
{
   NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:ZKUserModdelPath error:nil];
}

+ (void)judgeIsLogin
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionId=userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@"";
    }
    NSDictionary *params=@{
                           @"sessionId":sessionId
                           };
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/isLogin.do",baseUrl] params:params success:^(id json) {
        NSString *islogin= [[[json objectForKey:@"body"] objectForKey:@"data"] objectForKey:@"isLogin"];
        if (!islogin.integerValue) {
            [ZKUserTool deleteAccount];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

@end
