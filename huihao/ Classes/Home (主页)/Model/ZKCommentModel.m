
//
//  ZKCommentModel.m
//  huihao
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKCommentModel.h"
@implementation ZKCommentModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"ZKCommentModel description:%@\n zhenDescription: %@\nenvironment: %@\nyuanDescription: %@\nrecordWait: %@\ntreatTime: %@\nuserId: %@\ndiseaseName: %@\nuserImgUrl: %@\nzhenFlow: %@\nsymptomDescription: %@\ndepartmentName: %@\nimgList: %@\npjType: %@\nzhenFeeling: %@\nzhenAllCost: %@\nenvirement: %@\nguaWay: %@\nwaitTime: %@\nzhenId: %@\nyuanDay: %@\ntaste: %@\nnurseService: %@\nmajorSkill: %@\nyuanFeeling: %@\nyuanId: %@\ncellHeight: %f\n",[super description], self.zhenDescription, self.environment, self.yuanDescription, self.recordWait, self.treatTime, self.userId, self.diseaseName, self.userImgUrl, self.zhenFlow, self.symptomDescription, self.departmentName, self.imgList, self.pjType, self.zhenFeeling, self.zhenAllCost, self.envirement, self.guaWay, self.waitTime, self.zhenId, self.yuanDay, self.taste, self.nurseService, self.majorSkill, self.yuanFeeling, self.yuanId, self.cellHeight];
}
- (NSString *)guaWay
{
    switch (_guaWay.integerValue) {
        case ZKTujingTypeDaTing:
            return @"大厅";
            break;
        case ZKTujingTypeWangShang:
            return @"网上";
            break;
        case ZKTujingTypePengyou:
            return @"朋友";
            break;
        case ZKTujingTypeQita:
            return @"其他";
            break;
        default:
               return @"大厅";
            break;
    }
    return nil;
}
- (NSString *)zhenFlow
{
    switch (_zhenFlow.integerValue) {
        case ZKTujingTypeDaTing:
            return @"很好";
            break;
        case ZKTujingTypeWangShang:
            return @"好";
            break;
        case ZKTujingTypePengyou:
            return @"一般";
            break;
        case ZKTujingTypeQita:
            return @"很差";
            break;
        default:
            return @"很好";
            break;
    }
    return nil;

}
-(NSString *)recordWait
{
    switch (_recordWait.integerValue) {
        case ZKTujingTypeDaTing:
            return @"15分钟+";
            break;
        case ZKTujingTypeWangShang:
            return @"30分钟+";
            break;
        case ZKTujingTypePengyou:
            return @"1小时+";
            break;
        case ZKTujingTypeQita:
            return @"1天+";
            break;
        default:
            return @"15分钟+";
            break;
    }
}
-(NSString *)yuanDay
{
    switch (_yuanDay.integerValue) {
        case ZKTujingTypeDaTing:
            return @"1-3";
            break;
        case ZKTujingTypeWangShang:
            return @"4-6";
            break;
        case ZKTujingTypePengyou:
            return @"7-9";
            break;
        case ZKTujingTypeQita:
            return @"10+";
            break;
        default:
            return @"1-3";
            break;
    }
}

- (NSString *)symptomDescription
{
    if (_symptomDescription.length==0) {
        return @"无";
    }else
    {
        return _symptomDescription;
    }
}
- (NSString *)zhenDescription
{
    if (_zhenDescription.length==0) {
        return _yuanDescription;
    }
    return _zhenDescription;
}
@end
