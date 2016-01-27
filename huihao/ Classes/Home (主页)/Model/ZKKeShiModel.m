//
//  ZKKeShiModel.m
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKKeShiModel.h"
@implementation ZKKeShiModel



- (NSString *)description
{
    return [NSString stringWithFormat:@"ZKKeShiModel description:%@\n totalFeeling: %@\ndiseaseName: %@\nyuanFeeling: %@\n",[super description], self.totalFeeling, self.diseaseName, self.yuanFeeling];
}
@end
