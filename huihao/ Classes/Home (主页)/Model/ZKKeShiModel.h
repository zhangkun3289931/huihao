

//  ZKKeShiModel.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKKeShiModel : ZKBaseModel
/*
 "totalFeeling": "7.6",
 "imgUrl": "http://123.56.100.221:8080/upload/yiyuan/6ee62a9c561c4baea377d8d2ebaeb552.jpg",
 "diseaseName": "肾功能衰竭,中毒,尿毒症",
 "yuanFeeling": "10.0",
 "yuanUserAmount": "1",
 "areaName": "黑龙江",
 "zhenFeeling": "9.6",
 "totalUserAmount": "3",
 "hospitalName": "哈尔滨市第一医院",
 "zhenUserAmount": "2",
 "departmentId": "402881084e51c383014e51dec7cc001a",
 "departmentTypeName": "血液透析科",
 "hospitalBrief": ""
 */
@property (nonatomic, copy) NSString *totalFeeling;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString *diseaseName;
@property (nonatomic, copy) NSString *yuanFeeling;
@property (nonatomic, copy) NSString * areaName;
@property (nonatomic, copy) NSString * zhenFeeling;
@property (nonatomic, copy) NSString * hospitalName;
@property (nonatomic, copy) NSString * departmentId;
@property (nonatomic, copy) NSString * departmentTypeName;
@property (nonatomic, copy) NSString * hospitalBrief;
@end
