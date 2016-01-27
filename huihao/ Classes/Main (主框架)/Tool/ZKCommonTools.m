//
//  ZKCommonTools.m
//  huihao
//
//  Created by 张坤 on 15/10/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKCommonTools.h"
#import "ZKLoginViewController.h"
#import "ZKUserTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKConst.h"
@implementation ZKCommonTools
+ (BOOL)JudgeState:(NSDictionary *)json controller:(Class)controller
{
  NSString *state= [json objectForKey:@"state"];
    if (StateTypeSuccess==state.intValue) {
        return YES;
    }else
    {
        [MBProgressHUD showError:[json objectForKey:@"des"]];
        return NO;
    }
  
}
+ (BOOL)JudgeState:(NSDictionary *)json
{
    NSString *state= [json objectForKey:@"state"];
    return StateTypeNoLogin==state.intValue;
}

+ (UIColor *)customColor
{
    NSArray *customRandomColors = @[
                            ZKColor(117, 163, 215),
                             ZKColor(131, 116, 207),
                             ZKColor(161, 163, 175),
                             ZKColor(140, 185, 207),
                             ZKColor(225, 159, 57),
                             ZKColor(242, 112, 112),
                             ZKColor(142 , 185, 207),
                             ZKColor(230, 126, 122),
                             ZKColor(210, 190, 74),
                             ZKColor(240, 146, 172),
                             ZKColor(150, 184, 255),
                             ZKColor(189, 213, 75),
                             ZKColor(237, 130, 148),
                             ZKColor(180, 156, 240),
                             ZKColor(237, 201, 93),
                             ZKColor(147, 213, 240),
                             ZKColor(138, 173, 175),
                             ZKColor(242 , 144, 144),
                             ZKColor(272, 182, 126),
                             ZKColor(74, 127, 162)
                             
                             ];
    return customRandomColors[arc4random_uniform(20)];
    
}
@end
