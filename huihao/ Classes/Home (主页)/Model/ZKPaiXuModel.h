//
//  ZKPaiXuModel.h
//  huihao
//
//  Created by 张坤 on 15/10/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKPaiXuModel : NSObject
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) NSString *orderName;

+ (instancetype)initWithOrder:(NSString *)order andOrderName:(NSString *)orderName;
@end
