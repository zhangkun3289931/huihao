//
//  ZKTopicBaseViewController.h
//  huihao
//
//  Created by 张坤 on 15/12/18.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKHTTPTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKTopicModel.h"
#import "MJExtension.h"
#import "ZKTopicTableViewCell.h"
#import "ZKComposeViewController.h"
#import "ZKNavViewController.h"
#import "ZKUserTool.h"
#import "ZKLoginViewController.h"
#import "UIImageView+WebCache.h"
#import "ZKMeSpeakViewController.h"
#import "MJRefresh.h"

@interface ZKTopicBaseViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataSource;
/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;
- (NSString *)setupUrl;
- (void)setupUpHttpData;
@end
