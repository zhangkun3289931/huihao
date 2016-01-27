//
//  ZKDoctorModel.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKDoctorModel.h"

@implementation ZKDoctorModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"ZKDoctorModel description:%@\n doctorName: %@\nhospitalIntroduce: %@\ntotalScore: %@\nposition: %@\nareaName: %@\ndepartmentId: %@\nimageName: %@\ndepartmentName: %@\ndoctorImageId: %@\nareaId: %@\ndoctorId: %@\nhospitalLevel: %@\ngoodAt: %@\ndoctorIntroduce: %@\nareaType: %@\nhospitalImageId: %@\nsmartValue: %@\nrevalueNum: %@\nhospitalName: %@\ndiseaseMap: %@\ndiseaseName: %@\nhospitalDes: %@\nsymptom: %@\ndiseaseId: %@\n",[super description], self.doctorName, self.hospitalIntroduce, self.totalScore, self.position, self.areaName, self.departmentId, self.imageName, self.departmentName, self.doctorImageId, self.areaId, self.doctorId, self.hospitalLevel, self.goodAt, self.doctorIntroduce, self.areaType, self.hospitalImageId, self.smartValue, self.revalueNum, self.hospitalName, self.diseaseMap, self.diseaseName, self.hospitalDes, self.symptom, self.diseaseId];
}
@end
