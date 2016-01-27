//
//  ZKColumuModel.h
//  huihao
//
//  Created by Alex on 15/9/15.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface ZKColumuModel : NSObject
/** 图片地址*/
@property (nonatomic,copy) NSString *imgUrl;
/** 栏目内容*/
@property (nonatomic,copy) NSString *columnContent;
/** id*/
@property (nonatomic,copy) NSString *columnId;
/** title*/
@property (nonatomic,copy) NSString *columnTitle;
@end
