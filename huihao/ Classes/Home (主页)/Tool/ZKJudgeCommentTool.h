//
//  ZKJudgeCommentTool.h
//  huihao
//
//  Created by 张坤 on 15/12/31.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
#import "ZKHTTPTool.h"

@interface ZKJudgeCommentTool : NSObject

+ (BOOL) judgeCommentWithModel :(ZKKeShiModel *)keshiModel AtUrl :(NSString *)url ;

@end
