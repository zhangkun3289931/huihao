//
//  ZKHongBaoModel.h
//  huihao
//
//  Created by Alex on 15/9/30.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKHongBaoModel : ZKBaseModel
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *fee;
@property (nonatomic,copy) NSString *payState;
@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *payAccount;
@property (nonatomic,copy) NSString *accountDes;
@property (nonatomic,copy) NSString *orderId;
@end
