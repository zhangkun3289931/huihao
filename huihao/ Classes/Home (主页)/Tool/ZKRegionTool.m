//
//  ZKRegionTool.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKRegionTool.h"
// 账号的存储路径
#define ZKUserModdelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"region.archive"]
@implementation ZKRegionTool
+ (void)saveAccount:(ZKRegionModel *)region
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:region toFile:ZKUserModdelPath];
}

+ (ZKRegionModel *)region
{
    // 加载模型
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ZKUserModdelPath];
}
@end
