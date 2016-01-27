//
//  NSDate+ZKDate.h
//  微博
//
//  Created by 张坤 on 15/9/7.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZKDate)
- (BOOL)isThisYear;
- (BOOL)isThisTaday;
- (BOOL)isThisYestoday;
@end
