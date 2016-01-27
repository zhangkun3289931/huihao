//
//  ZKGroupModel.h
//  huihao
//
//  Created by 张坤 on 15/10/16.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZKGroupModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, assign) NSInteger online;
@property (nonatomic, strong) UIImage *imgName;
@property (nonatomic, assign, getter = isOpened) BOOL opened;
+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
