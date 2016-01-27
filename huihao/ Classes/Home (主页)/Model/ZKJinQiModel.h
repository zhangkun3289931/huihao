//
//  ZKJinQiModel.h
//  huihao
//
//  Created by Alex on 15/9/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKJinQiModel : ZKBaseModel

@property (nonatomic,copy) NSString *userImgUrl;
@property (nonatomic,copy) NSString *flagContent;
@property (nonatomic,copy) NSString *flagImgUrl;
@property (nonatomic,assign,getter=isDIY) BOOL isDIY;
@end
