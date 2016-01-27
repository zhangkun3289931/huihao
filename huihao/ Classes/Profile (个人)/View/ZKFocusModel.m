
//
//  ZKFocusModel.m
//  huihao
//
//  Created by 张坤 on 15/10/10.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKFocusModel.h"

@implementation ZKFocusModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"ZKFocusModel description:%@\n userId: %@\ndoctorName: %@\ndepartmentName: %@\nhospitalName: %@\ndoctorId: %@\ndepartmentId: %@\nisSelected: %i\ntype: %zd\n",[super description], self.userId, self.doctorName, self.departmentName, self.hospitalName, self.doctorId, self.departmentId, self.isSelected, self.type];
}

+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
