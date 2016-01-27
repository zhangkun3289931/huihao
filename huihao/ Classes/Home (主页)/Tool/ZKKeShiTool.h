//
//  ZKKeShiTool.h
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKKeShi.h"
@interface ZKKeShiTool : NSObject
+ (void)saveAccount:(ZKKeShi *)keshi;
+ (ZKKeShi *)keshi;
@end
