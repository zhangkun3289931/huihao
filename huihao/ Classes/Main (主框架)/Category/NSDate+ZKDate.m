
//
//  NSDate+ZKDate.m
//  微博
//
//  Created by 张坤 on 15/9/7.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "NSDate+ZKDate.h"

@implementation NSDate (ZKDate)
- (BOOL)isThisYear
{
    //日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDate *currentDate=[NSDate date];
    NSInteger createComponent=[calendar component:NSCalendarUnitYear fromDate:self];
    NSInteger currentComponent=[calendar component:NSCalendarUnitYear fromDate:currentDate];
    return createComponent==currentComponent;
}
- (BOOL)isThisYestoday
{
    //NSTimeInterval inter=[date timeIntervalSinceDate:[NSDate date]];
    //先转成只有年月日的只字符串
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    NSString *currentDate=[fmt stringFromDate:[NSDate date]];
    NSString *createDate=[fmt stringFromDate:self];
    //在转换成时间
    NSDate *date1=[fmt dateFromString:currentDate];
    NSDate *now=[fmt dateFromString:createDate];
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    CFCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps=[calendar components:unit fromDate:date1 toDate:now options:0];
    if (comps.year==0 && comps.month==0 && comps.day==1) {
        return YES;
    }
    return NO;
    
}
- (BOOL)isThisTaday
{
    //NSTimeInterval inter=[date timeIntervalSinceDate:[NSDate date]];
    //先转成只有年月日的只字符串
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    NSString *currentDate=[fmt stringFromDate:[NSDate date]];
    NSString *createDate=[fmt stringFromDate:self];
    return [currentDate isEqualToString:createDate];
}
@end
