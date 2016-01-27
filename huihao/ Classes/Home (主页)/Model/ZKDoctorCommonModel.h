
//  ZKDoctorCommonModel.h
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKDoctorCommonModel : ZKBaseModel


@property (nonatomic, copy) NSString *greet;
@property (nonatomic, copy) NSString *diseaseName;
@property (nonatomic, copy) NSString *pjType;
@property (nonatomic, copy) NSString *diseaseId;
@property (nonatomic, copy) NSString *teach;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *symptom;
@property (nonatomic, copy) NSString *userImageUrl;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *hospitalDes;
@property (nonatomic, copy) NSString *doctorId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *healthAfter;
@property (nonatomic, copy) NSString *report;
@property (nonatomic, copy) NSString *totalMark;
@property (nonatomic, copy) NSString *skill;
@property (nonatomic, copy) NSString *roundAttitude;
@property (nonatomic,assign) CGFloat cellHeight;

@end
