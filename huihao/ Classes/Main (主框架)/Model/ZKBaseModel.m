//
//  ZKBaseModel.m
//  huihao
//
//  Created by 张坤 on 15/10/27.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKBaseModel.h"
#import "NSDate+ZKDate.h"
@implementation ZKBaseModel
- (NSString *)realName
{
    if (_realName.length==0) {
        return _nickName;
    }
    return _realName;
}
- (NSString *)nickName
{
    if (_nickName.length==0) {
        return  [_userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return _nickName;
}
- (NSString *)username
{
    if (_username.length==0) {
        return _userName;
    }
    return  [_username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
- (NSString *)userName
{
    if (_userName.length==0) {
        return @"--";
    }else
    {
        return  [_userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
}
- (NSString *)time
{
    return [self timeChuLi:_time];
}
- (NSString *)yuanCreatTime
{
    return [self timeChuLi:_yuanCreatTime];
}
-(NSString *)creatTime
{
    return [self timeChuLi:_creatTime];
}
- (NSString *)zhenCreatTime
{
    return [self timeChuLi:_zhenCreatTime];
}

-(NSString *)totalUserAmount
{
    return [self NumCount:_totalUserAmount];
}
- (NSString *)zhenUserAmount
{
    return [self NumCount:_zhenUserAmount];
}

- (NSString *)yuanUserAmount
{
    //_yuanUserAmount=@"12345";
     return [self NumCount:_yuanUserAmount];
}
- (NSString *)smartValue
{
    return [self NumCount: _smartValue];
}
- (NSString *)revalueNum
{
    return [self NumCount: _revalueNum];
}
- (NSString *)yuanCost
{
    return [self NumCount:_yuanCost];
}
- (NSString *)operationCost
{
    return [self NumCount:_operationCost];
}
- (NSString *)zhenDrugCost
{
    return _zhenDrugCost;
}
- (NSString *)zhenCheckCost
{
    return _zhenCheckCost;
}




/**
 *  评论数／ 费用 处理
 *
 *  @param countStr <#countStr description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)NumCount:(NSString *)countStr{
    int count=countStr.intValue;
    if (count) { // 数字不为0
        if (count < 10000) { // 不足10000：直接显示数字，比如786、7986
          return  [NSString stringWithFormat:@"%d", count];
        } else { // 达到10000：显示xx.x万，不要有.0的情况
            double wan = count / 10000.0;
          NSString *title = [NSString stringWithFormat:@"%.4f万", wan];
            // 将字符串里面的.0去掉
         return  title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        return @"0";
    }
   return @"0";
}
/**
 *  时间处理
 *
 *  @param timeChuLi <#timeChuLi description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)timeChuLi:(NSString *)timeChuLi
{
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];//真机调试要加上这句代码
    //EEE MMM dd HH:mm:ss Z yyyy
    //设置日期的格式，生命字符串里面每个数字的含义
    //2015-09-16 10:22:15
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createDate=[df dateFromString:timeChuLi];
  //  NSDate *currentDate=[NSDate date];
    //日历对象
  //  NSCalendar *calendar=[NSCalendar currentCalendar];
   // CFCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond;
    
   // NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //NSDateComponents *component=[calendar components:unit fromDate:createDate toDate:currentDate options:0];
    
    
    if ([createDate isThisYear])
    {
        //是今年
//        if ([createDate isThisTaday]) {//今天
//            if(component.hour==0)//几分钟之前
//            {
//                //if (component.minute>=30) {
//                    return [NSString stringWithFormat:@"%ld分钟之前",component.minute];
//               // }
////                else
////                {
////                    return [NSString stringWithFormat:@"刚刚"];
////                }
//            }
//            else
//            {
//                return [NSString stringWithFormat:@"%ld小时之前",component.hour];
//            }
//            
//        }else if ([createDate isThisYestoday])//昨天
//        {
//            [df setDateFormat:@"昨天 HH:mm"];
//            return [df stringFromDate:createDate];
//        }else//其他
//        {
            [df setDateFormat:@"MM-dd HH:mm"];
            return [df stringFromDate:createDate];
       // }
    }else
    {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [df stringFromDate:createDate];
    }
    //NSLog(@"%@===%@",_creatTime,creatDate);
    return  _creatTime;
}
@end
