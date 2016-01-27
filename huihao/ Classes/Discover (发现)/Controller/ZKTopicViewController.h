//
//  ZKTopicViewController.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTopicBaseViewController.h"
#import "ZKColumuModel.h"
#import "ZKSearchHotModel.h"
@interface ZKTopicViewController : ZKTopicBaseViewController
@property (nonatomic,strong) ZKColumuModel *colnmuModel;
@property (nonatomic,strong) ZKSearchHotModel *hotModel;

@end
