//
//  ZKRegionTool.h
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKRegionModel.h"

@interface ZKRegionTool : NSObject
+ (void)saveAccount:(ZKRegionModel *)region;
+ (ZKRegionModel *)region;
@end
