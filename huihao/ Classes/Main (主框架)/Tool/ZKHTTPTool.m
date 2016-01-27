//
//  ZKHTTPTool.m
//  微博
//
//  Created by 张坤 on 15/9/13.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKHTTPTool.h"

#import "AFHTTPSessionManager.h"
#import "ZKLoginViewController.h"

static const NSTimeInterval outTime = 10;
static NSString*const AFAppDotNetAPIBaseURLString =@"https://api.app.net/";

@interface ZKHTTPTool ()
@property (nonatomic,strong)  AFHTTPRequestOperationManager *manager;
@end

@implementation ZKHTTPTool
+ (BOOL)sharedClient
{

    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    __block BOOL isNetWorking= YES;
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                isNetWorking = NO;
                NSLog(@"没有网络(断网)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
    return isNetWorking;
}


+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success state:(void (^)(NSString *))state failure:(void (^)(NSError *))failure;
{
   
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:outTime];
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation,NSDictionary *responseObject) {
        if (success) {
            if ([ZKCommonTools JudgeState:responseObject controller:nil]) {
                if ([ZKCommonTools JudgeState:responseObject]) {
                    state(@"-106");
                }
                success(responseObject);
            };
           // [MBProgressHUD hideHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            [MBProgressHUD hideHUD];
            failure(error);
        }
    }];

}
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
      [manager.requestSerializer setTimeoutInterval:outTime];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation,NSDictionary *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            [MBProgressHUD hideHUD];
            failure(error);
        }
    }];
}
+(void)POST:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:outTime];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation,NSDictionary *responseObject) {
        if (success) {
            [MBProgressHUD hideHUD];
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json)) success
       state:(void (^)(NSString *))state failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:outTime];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation,NSDictionary *responseObject) {
        if (success) {
            
            if ([ZKCommonTools JudgeState:responseObject]) {
                state(@"-106");
                [MBProgressHUD hideHUD];
              
            }else
            {
                if ([ZKCommonTools JudgeState:responseObject controller:nil]) {
                    success(responseObject);
                    //  [MBProgressHUD hideHUD];
                };
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            [MBProgressHUD hideHUD];
            failure(error);
            //[MBProgressHUD showError: LoaderString(@"noHttpLoadText")];
            
        }
    }];
}


+ (void)POST:(NSString *)url params:(NSDictionary *)params  success:(void (^)(id json)) success
       state:(void (^)(NSString *))state failure:(void (^)(NSError *error))failure andController:(UIViewController *)vc
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
      [manager.requestSerializer setTimeoutInterval:outTime];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation,NSDictionary *responseObject) {
        if (success) {
          
            if ([ZKCommonTools JudgeState:responseObject]) {
                state(@"-106");
                [MBProgressHUD hideHUD];
                
                ZKLoginViewController *login = [[ZKLoginViewController alloc]init];
                
                [vc.navigationController presentViewController:login animated:YES completion:nil ]
                ;
            }else
            {
                if ([ZKCommonTools JudgeState:responseObject controller:nil]) {
                    success(responseObject);
                    //  [MBProgressHUD hideHUD];
                };
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            [MBProgressHUD hideHUD];
            failure(error);
            //[MBProgressHUD showError: LoaderString(@"noHttpLoadText")];
            
        }
    }];
}
+(void)POST:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:outTime];
    // 3.发送请求
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (block) {
            block(formData);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
