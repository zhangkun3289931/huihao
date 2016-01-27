
//
//  ZKKeShiTool.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKKeShiTool.h"

@implementation ZKKeShiTool
// 账号的存储路径
#define ZKUserModdelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"keshi.archive"]
+ (void)saveAccount:(ZKKeShi *)keshi
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:keshi toFile:ZKUserModdelPath];
}

+ (ZKKeShi *)keshi
{
    // 加载模型
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ZKUserModdelPath];
}
@end
