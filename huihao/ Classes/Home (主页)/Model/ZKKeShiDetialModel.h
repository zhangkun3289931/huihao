
//  ZKKeShiDetialModel.h
//  huihao
//
//  Created by 张坤 on 15/10/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKKeShiDetialModel : NSObject
@property (nonatomic,copy) NSString *diseaseName;
@property (nonatomic,copy) NSString *hospitalBrief;
@property (nonatomic,copy) NSString *yuanFeeling;
@property (nonatomic,copy) NSString *hospitalName;
@property (nonatomic,copy) NSString *yuanUserAmount;
@property (nonatomic,copy) NSString *totalUserAmount;
@property (nonatomic,copy) NSString *zhenFeeling;
@property (nonatomic,copy) NSString *totalFeeling;
@property (nonatomic,copy) NSString *flagCount;
@property (nonatomic,copy) NSString *concernCount;
@property (nonatomic,strong) NSURL *imgUrl;
@property (nonatomic,copy) NSString *departmentTypeName;


@end
