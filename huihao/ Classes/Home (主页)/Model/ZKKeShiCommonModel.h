//
//  ZKKeShiCommonModel.h
//  huihao
//
//  Created by 张坤 on 15/10/13.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKKeShiCommonModel : UITextView
@property (nonatomic,strong) NSURL *imgUrl;
@property (nonatomic,copy) NSString *concern;
@property (nonatomic,assign) NSInteger flagCount;
@property (nonatomic,copy) NSString *departmentName;
@property (nonatomic,assign) NSInteger concernCount;
@property (nonatomic,copy) NSString *hospitalName;
@property (nonatomic,copy) NSString *hospitalBrief;
@property (nonatomic,strong) NSString *diseaseMap;
@property (nonatomic,strong) NSDictionary *departmentId;

@end
