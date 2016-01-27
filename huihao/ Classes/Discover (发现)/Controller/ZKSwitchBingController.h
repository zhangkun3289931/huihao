//
//  ZKSwitchBingController.h
//  huihao
//
//  Created by 张坤 on 15/12/2.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSwitchBingController;
@protocol ZKSwitchBingControllerDelegate <NSObject>

- (void)switchItem:(ZKSwitchBingController *)switchI switchWithItem:(NSArray *)tags;

@end
@interface ZKSwitchBingController : UITableViewController
@property (nonatomic,weak) id<ZKSwitchBingControllerDelegate> delagate;
@end
