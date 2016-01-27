//
//  ZKFileReadWriteTool.m
//  huihao
//
//  Created by 张坤 on 15/9/19.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKFileReadWriteTool.h"

//得到完整的文件名
#define filePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]
@implementation ZKFileReadWriteTool
+ (NSDictionary *)read:(NSString *)fileName
{
    return [[NSDictionary alloc]initWithContentsOfFile: [filePath  stringByAppendingPathComponent:fileName]];
}
+ (void)write:(NSDictionary *)json fileName:(NSString *)fileName
{
   
    [json writeToFile:[filePath  stringByAppendingPathComponent:fileName] atomically:YES];
}
+ (NSArray *)readArray:(NSString *)fileName
{
    return [[NSArray alloc]initWithContentsOfFile:[filePath  stringByAppendingPathComponent:fileName]];
}
+ (void)writeArray:(NSArray *)json fileName:(NSString *)fileName
{
     NSLog(@"%@",[filePath  stringByAppendingPathComponent:fileName]);
    [json writeToFile:[filePath  stringByAppendingPathComponent:fileName] atomically:YES];
}
+ (void)removeFile:(NSString *)fileName
{
    //清除plist文件，可以根据我上面讲的方式进去本地查看plist文件是否被清除
    NSFileManager *fileMger = [NSFileManager defaultManager];
   [fileMger removeItemAtPath:[filePath  stringByAppendingPathComponent:fileName] error:nil];
}
@end
