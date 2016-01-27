//
//  ZKTabBar.h
//  微博
//
//  Created by 张坤 on 15/9/1.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKTabBar;
@protocol ZKTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabbarDidClickButton:(ZKTabBar *)tabBar;
@end
@interface ZKTabBar : UITabBar
@property (nonatomic, weak) id<ZKTabBarDelegate> delegate;
@end
