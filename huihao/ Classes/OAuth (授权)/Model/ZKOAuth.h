//
//  ZKOAuth.h
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKOAuth : NSObject <NSCoding>
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *remind_in;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
+ (instancetype)oauthWithDict:(NSDictionary *)dict;
@end
