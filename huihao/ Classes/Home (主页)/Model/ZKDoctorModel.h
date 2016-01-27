
//  ZKDoctorModel.h
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKDoctorModel : NSObject
/** 姓名*/
@property (nonatomic,copy) NSString *doctorName;
/** 医院介绍*/
@property (nonatomic,copy) NSString *hospitalIntroduce;
/**总分*/
@property (nonatomic,copy) NSString *totalScore;

/** 主任医师*/
@property (nonatomic,copy) NSString *position;
/** 地区*/
@property (nonatomic,copy) NSString *areaName;
/** 地区ID*/
@property (nonatomic,copy) NSString *departmentId;
/** 图片名称*/
@property (nonatomic,copy) NSString *imageName;
/** 科室名称*/
@property (nonatomic,copy) NSString *departmentName;
/** 医生的照片D*/
@property (nonatomic,copy) NSString *doctorImageId;
/** 地域ID*/
@property (nonatomic,copy) NSString *areaId;
/** 医生ID*/
@property (nonatomic,copy) NSString *doctorId;
/** 医生等级*/
@property (nonatomic,copy) NSString *hospitalLevel;
/** 擅长*/
@property (nonatomic,copy) NSString *goodAt;
/** doctorIntroduce*/
@property (nonatomic,copy) NSString *doctorIntroduce;
/** areaType*/
@property (nonatomic,copy) NSString *areaType;
/** 医院照片*/
@property (nonatomic,copy) NSString *hospitalImageId;
/** 魅力值*/
@property (nonatomic,copy) NSString *smartValue;
/** 多少人评*/
@property (nonatomic,copy) NSString *revalueNum;
/** 医院名*/
@property (nonatomic,copy) NSString *hospitalName;
/** 病集合*/
@property (nonatomic,copy) NSDictionary *diseaseMap;
@property (nonatomic,copy) NSDictionary *diseaseName;
@property (nonatomic,copy) NSDictionary *hospitalDes;
@property (nonatomic,copy) NSDictionary *symptom;
@property (nonatomic,copy) NSDictionary *diseaseId;
@end
