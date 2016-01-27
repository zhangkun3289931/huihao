//
//  ZKSearchModel.h
//  huihao
//
//  Created by 张坤 on 15/11/19.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKSearchModel : NSObject
//医生姓名
@property (nonatomic,copy) NSString *type;
//医生姓名
@property (nonatomic,copy) NSString *display;
//医院名称  医生拼音  前端加个字
@property (nonatomic,copy) NSString *displayLabel;
@end
