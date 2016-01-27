//
//  ZKZhangDanModel.h
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKZhangDanModel : ZKBaseModel
/** userId*/
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,assign)  ZKBillState payType;
@property (nonatomic,copy) NSString *payState;
@property (nonatomic,copy) NSString *payAccount;
@property (nonatomic,copy) NSString *fee;
@property (nonatomic,copy) NSString *accountDes;
@end
