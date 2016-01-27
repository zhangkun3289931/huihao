

//  ZKFocusModel.h
//  huihao
//
//  Created by 张坤 on 15/10/10.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKFocusModel : ZKBaseModel
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *doctorName;
@property (nonatomic,copy) NSString *departmentName;
@property (nonatomic,copy) NSString *hospitalName;
@property (nonatomic,copy) NSString *doctorId;
@property (nonatomic,copy) NSString *departmentId;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger type;
+ (instancetype)friendWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
