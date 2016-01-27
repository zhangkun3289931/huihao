//
//  ZKDoctorCommonModel.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDoctorCommonModel.h"

@implementation ZKDoctorCommonModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"ZKDoctorCommonModel description:%@\n greet: %@\ndiseaseName: %@\npjType: %@\ndiseaseId: %@\nteach: %@\nuuid: %@\nsymptom: %@\nuserImageUrl: %@\ndes: %@\nhospitalDes: %@\ndoctorId: %@\nuserId: %@\nhealthAfter: %@\nreport: %@\ntotalMark: %@\nskill: %@\nroundAttitude: %@\ncellHeight: %f\n",[super description], self.greet, self.diseaseName, self.pjType, self.diseaseId, self.teach, self.uuid, self.symptom, self.userImageUrl, self.des, self.hospitalDes, self.doctorId, self.userId, self.healthAfter, self.report, self.totalMark, self.skill, self.roundAttitude, self.cellHeight];
}
// 
- (NSString *)symptom
{
    if (_symptom.length==0) {
        return  [NSString stringWithFormat:@"无"];
    }else
    {
        return  [NSString stringWithFormat:@"%@",_symptom];
    }
}
- (NSString *)des
{
    if (_des.length==0) {
        return self.hospitalDes;
    }
    return _des;
}
@end
