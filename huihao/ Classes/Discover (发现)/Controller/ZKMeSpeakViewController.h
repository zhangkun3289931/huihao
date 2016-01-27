//
//  ZKMeSpeakViewController.h
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTopicModel.h"
@interface ZKMeSpeakViewController : UITableViewController
@property (nonatomic,strong) ZKTopicModel *topicModel;
@property (nonatomic,assign) BOOL isRefersh ;
@end
