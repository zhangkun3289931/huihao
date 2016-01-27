//
//  ZKJudgeCommentTool.m
//  huihao
//
//  Created by 张坤 on 15/12/31.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKJudgeCommentTool.h"

@implementation ZKJudgeCommentTool
+ (BOOL) judgeCommentWithModel :(ZKKeShiModel *)keshiModel  AtUrl :(NSString *)url {

    __block BOOL isJufge = YES;
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sesseionId=@"";
    if (userModel!=NULL) sesseionId = userModel.sessionId;
    
    NSDictionary *params=@{
                           @"sessionId":sesseionId,
                           @"departmentId":keshiModel.departmentId
                           };
    
    [ZKHTTPTool POST:url params:params success:^(id json) {
        NSLog(@"%@",json);
        isJufge = NO;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
    
    return isJufge;
}
@end
