
//
//  ZKOAuthTool.m
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKOAuthTool.h"
#define kPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation ZKOAuthTool
+ (void)save:(ZKOAuth *)oauth
{
    //获得账号存储的时间
  //  NSDate *currentTime=[NSDate date];
    //自定义对象的存储必须使用NSKeyedArchiver
    [NSKeyedArchiver archiveRootObject:oauth toFile:kPath];
}
+ (ZKOAuth *)oauth
{
  ZKOAuth *oauth=  [NSKeyedUnarchiver unarchiveObjectWithFile:kPath];
    //过期的秒数
  //long long  expires_in= [oauth.expires_in longLongValue];
    //获取当前的时间
    //NSDate *nowTime=[NSDate date];
    //利用 创建token的时间，跟过期时间，  判断
   // [nowTime compare:<#(NSDate *)#>]
    return oauth;
}
@end
