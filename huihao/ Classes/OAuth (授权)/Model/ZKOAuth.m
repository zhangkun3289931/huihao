//
//  ZKOAuth.m
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKOAuth.h"
#import "MJExtension.h"
@implementation ZKOAuth
+ (instancetype)oauthWithDict:(NSDictionary *)dict
{
    ZKOAuth *oauth=[[ZKOAuth alloc]init];
    //[oauth setValuesForKeysWithDictionary:dict];
    oauth.access_token=dict[@"access_token"];
    oauth.expires_in=dict[@"expires_in"];
    oauth.uid=dict[@"uid"];
   // oauth.name=dict[@"uid"];
    oauth.remind_in=dict[@"remind_in"];
    return oauth;
}

/**
 *  归档进沙盒之前，就会调用这个个方法。  目的：说明这个对象的那些属性要归档到沙盒
 *
 *  @param aCoder <#aCoder description#>
 */
- (void)encodeWithCoder:(NSCoder *)encode
{
    [encode encodeObject:self.access_token forKey:@"access_token"];
    [encode encodeObject:self.expires_in forKey:@"expires_in"];
    [encode encodeObject:self.uid forKey:@"uid"];
      [encode encodeObject:self.name forKey:@"name"];
}
/**
 *  解档的时候调用
 *
 *  @param decoder <#decoder description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self=[super init]) {
        self.access_token= [decoder decodeObjectForKey:@"access_token"];
        self.expires_in=[decoder decodeObjectForKey:@"expires_in"];
        self.uid=[decoder decodeObjectForKey:@"uid"];
        self.name=[decoder decodeObjectForKey:@"name"];

    }
    return self;
}
@end
