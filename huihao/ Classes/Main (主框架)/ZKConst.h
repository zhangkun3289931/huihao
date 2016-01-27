//
//  ZKConst.h
//  微博
//
//  Created by 张坤 on 15/9/13.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKNavViewController.h"
#import "UIBarButtonItem+ZKExtaion.h"
#import "ZKHTTPTool.h"
#import "ZKUserTool.h"
#import "huihao.pch"

//   300 鲜花 =》消费
// 200 =》充值
// 400 =》提现
typedef enum {
    ZKBillStateRegion = 100, //锦旗
    ZKBillStateFlower = 300, //鲜花
    ZKBillStatePay = 200, //充值
    ZKBillStateKiting = 400, //提现
}ZKBillState;

typedef enum {
    ZKCommentStateDoctorMZ = -114,
    ZKCommentStateDoctorZY = -115,
    ZKCommentStateDepartmentMZ = -112,
    ZKCommentStateDepartmentZY = -113,
}ZKCommentState;

typedef enum{
    ZKDropDataTypeRegion=0,
    ZKDropDataTypeKeshi,
    ZKDropDataTypeBingZhong,
    ZKDropDataTypePaiXu
} ZKDropDataType;
typedef enum
{
    SourceTypeCamera=0,
    SourceTypeLibary
}SourceType;
typedef enum
{
    SexTypeBoy=0,
    SexTypeGril,
    SexTypeNo
}SexType;
#define ZKNotificationCenter [NSNotificationCenter defaultCenter]

#define UIScerrenHeight  self.view.bounds.size.height
#define UIScerrenWidth  self.view.bounds.size.width

//账号信息
extern NSString *const kClient_id;
extern NSString *const kRedirect_uri;
extern NSString *const kClient_secret;

extern NSString *const baseUrl;

extern NSString *const ZKTopicPublishSuccessNotification;

extern NSString *const ZKHomeKeshiResutTypeNotification ;
extern NSString *const ZKHomeDoctorResutTypeNotification ;

extern NSString *const ZKHomeSegSwitchNotification ;

extern NSString *const ZKSearchHotPlist;

extern NSString *const ZKCenterNotification;

extern BOOL isLoadHotData;

