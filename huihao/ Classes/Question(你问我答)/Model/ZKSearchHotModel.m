//
//  ZKSearchHotModel.m
//  huihao
//
//  Created by 张坤 on 15/11/30.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSearchHotModel.h"

@implementation ZKSearchHotModel
/**
 *  归档进沙盒之前，就会调用这个个方法。  目的：说明这个对象的那些属性要归档到沙盒
 *
 *  @param aCoder <#aCoder description#>
 */
- (void)encodeWithCoder:(NSCoder *)encode
{
    [encode encodeObject:self.display forKey:@"display"];
    [encode encodeObject:self.objid forKey:@"objid"];
}
/**
 *  解档的时候调用
 *
 *  @param decoder <#decoder description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self=[super init]) {
        self.display= [decoder decodeObjectForKey:@"display"];
        self.objid=[decoder decodeObjectForKey:@"objid"];
        
    }
    return self;
}

@end
