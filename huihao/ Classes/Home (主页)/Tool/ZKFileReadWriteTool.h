//
//  ZKFileReadWriteTool.h
//  huihao
//
//  Created by 张坤 on 15/9/19.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKFileReadWriteTool : NSObject
+ (NSDictionary *)read:(NSString *)fileName;
+ (void)write:(NSDictionary *)json fileName:(NSString *)fileName;
+ (NSArray *)readArray:(NSString *)fileName;
+ (void)writeArray:(NSArray *)json fileName:(NSString *)fileName;
+ (void)removeFile:(NSString *)fileName;
@end
