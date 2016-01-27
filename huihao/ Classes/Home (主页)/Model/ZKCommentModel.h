
//  ZKCommentModel.h
//  huihao
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
typedef enum
{
    ZKTujingTypeDaTing=1,
    ZKTujingTypeWangShang,
    ZKTujingTypePengyou,
    ZKTujingTypeQita
}ZKTujingType;
@interface ZKCommentModel : ZKBaseModel

/** 描述*/
@property (nonatomic,copy) NSString *zhenDescription;
@property (nonatomic,copy) NSString *environment;
@property (nonatomic,copy) NSString *yuanDescription;
/** 描述*/
@property (nonatomic,copy) NSString *recordWait;
/** 描述*/
@property (nonatomic,copy) NSString *treatTime;
/** 描述*/
@property (nonatomic,copy) NSString *userId;
/** 描述*/
@property (nonatomic,copy) NSString *diseaseName;
/** 描述*/
@property (nonatomic,copy) NSString *userImgUrl;
/** 描述*/
@property (nonatomic,copy) NSString *zhenFlow;
/** 描述*/
@property (nonatomic,copy) NSString *symptomDescription;

/** 描述*/
/** 描述*/
@property (nonatomic,copy) NSString *departmentName;
/** 描述*/
@property (nonatomic,copy) NSArray *imgList;
/** 描述*/
@property (nonatomic,copy) NSString *pjType;
@property (nonatomic,copy) NSString *zhenFeeling;
@property (nonatomic,copy) NSString *zhenAllCost;
@property (nonatomic,copy) NSString *envirement;
@property (nonatomic,copy) NSString *guaWay;
@property (nonatomic,copy) NSString *waitTime;
@property (nonatomic,copy) NSString *zhenId;
@property (nonatomic,copy) NSString *yuanDay;
@property (nonatomic,copy) NSString *taste;
@property (nonatomic,copy) NSString *nurseService;
@property (nonatomic,copy) NSString *majorSkill;
@property (nonatomic,copy) NSString *yuanFeeling;
@property (nonatomic,copy) NSString *yuanId;
@property (nonatomic,assign) CGFloat cellHeight;
@end
