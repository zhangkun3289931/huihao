//
//  ZKOAuthTool.h
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKOAuth.h"
@interface ZKOAuthTool : NSObject
+ (void)save:(ZKOAuth *)oauth;
+ (ZKOAuth *)oauth;
@end
