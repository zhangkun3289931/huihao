//
//  ZKComposeViewController.h
//  huihao
//
//  Created by 张坤 on 15/9/19.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKColumuModel.h"
#import "ZKTopicModel.h"
@class ZKComposeViewController;
@protocol ZKComposeViewControllerDelegate <NSObject>

@optional
- (void) composeViewController:(ZKComposeViewController *)vc withBingName:(NSString *)bingName;
@end
@interface ZKComposeViewController : UIViewController
@property (nonatomic,strong) ZKColumuModel *colnmuModel;
@property (nonatomic,strong) ZKTopicModel *topicModel;
@property (nonatomic,weak) id<ZKComposeViewControllerDelegate> delegate;
@end
