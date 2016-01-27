
//
//  ZKGroupModel.m
//  huihao
//
//  Created by 张坤 on 15/10/16.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKGroupModel.h"
#import "ZKFocusModel.h"
@implementation ZKGroupModel
+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    
        NSMutableArray *friendArray = [NSMutableArray array];
        for (NSDictionary *dict in self.friends) {
            ZKFocusModel *friend = [ZKFocusModel friendWithDict:dict];
            [friendArray addObject:friend];
        }
        self.friends = friendArray;
    }
    return self;
}

@end
