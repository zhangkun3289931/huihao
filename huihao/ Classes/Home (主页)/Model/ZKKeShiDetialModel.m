//
//  ZKKeShiDetialModel.m
//  huihao
//
//  Created by 张坤 on 15/10/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKKeShiDetialModel.h"

@implementation ZKKeShiDetialModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"ZKKeShiDetialModel description:%@\n diseaseName: %@\nhospitalBrief: %@\nyuanFeeling: %@\nhospitalName: %@\nyuanUserAmount: %@\ntotalUserAmount: %@\nzhenFeeling: %@\ntotalFeeling: %@\nflagCount: %@\nconcernCount: %@\nimgUrl: %@\ndepartmentTypeName: %@\n",[super description], self.diseaseName, self.hospitalBrief, self.yuanFeeling, self.hospitalName, self.yuanUserAmount, self.totalUserAmount, self.zhenFeeling, self.totalFeeling, self.flagCount, self.concernCount, self.imgUrl, self.departmentTypeName];
}
- (NSString *)hospitalBrief
{
    if (_hospitalBrief.length==0)
    {
        return @"简介：暂无";
    }
    else
    {
        return [NSString stringWithFormat:@"简介:%@",_hospitalBrief];
    }
}
@end
