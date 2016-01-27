//
//  ZKHTTPTool.h
//  微博
//
//  Created by 张坤 on 15/9/13.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ZKHTTPTool : NSObject

+ (BOOL)sharedClient;

+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success state:(void (^)(NSString *))state failure:(void (^)(NSError *))failure;
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)POST:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json)) success
     failure:(void (^)(NSError *error))failure;
+ (void)POST:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json)) success
     state:(void (^)(NSString *))state failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json)) success
       state:(void (^)(NSString *))state failure:(void (^)(NSError *error))failure andController:(UIViewController *)vc;
+(void)POST:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
