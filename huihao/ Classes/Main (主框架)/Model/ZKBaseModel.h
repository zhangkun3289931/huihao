//
//  ZKBaseModel.h
//  huihao
//
//  Created by 张坤 on 15/10/27.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKBaseModel : NSObject
/** 用户姓名*/
@property (nonatomic,copy) NSString *userName;
@property (nonatomic, copy) NSString *username;
/** 评论昵称*/
@property (nonatomic,copy) NSString *nickName;
/** 匿名*/
@property (nonatomic,copy) NSString *realName;
/** 评论创建时间*/
@property (nonatomic,copy) NSString *creatTime;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *yuanCreatTime;
@property (nonatomic,copy) NSString *zhenCreatTime;
/** 有用数*/
@property (nonatomic,assign) NSInteger useful;
/** 没用数*/
@property (nonatomic,assign) NSInteger useless;
/** 状态*/
@property (nonatomic,assign) NSInteger useState;


/******************评论数处理*******************************/
/** 总评论数处理*/
@property (nonatomic, copy) NSString *totalUserAmount;
/** 科室评论数*/
@property (nonatomic, copy) NSString *zhenUserAmount;
/** 医院评论数*/
@property (nonatomic, copy) NSString *yuanUserAmount;
/** 魅力值*/
@property (nonatomic,copy) NSString *smartValue;
/** 多少人评*/
@property (nonatomic,copy) NSString *revalueNum;
/******************费用处理*******************************/
/** 住院费用*/
@property (nonatomic,copy) NSString *yuanCost;
/** 总费用*/
@property (nonatomic,copy) NSString *operationCost;
/** 药品费用*/
@property (nonatomic,copy) NSString *zhenDrugCost;
/** 检查费用*/
@property (nonatomic,copy) NSString *zhenCheckCost;
@end
