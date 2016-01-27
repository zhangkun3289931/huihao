//
//  ZKPaiXuModel.m
//  huihao
//
//  Created by 张坤 on 15/10/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKPaiXuModel.h"

@implementation ZKPaiXuModel
+ (instancetype)initWithOrder:(NSString *)order andOrderName:(NSString *)orderName
{
    ZKPaiXuModel *model=[[ZKPaiXuModel alloc]init];
    model.order=order;
    model.orderName=orderName;
    return model;
}
@end
