//
//  UITableView+ZKTableView.h
//  huihao
//
//  Created by 张坤 on 16/1/14.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZKTableView)
- (void) showErrorHint;
- (BOOL) showErrorHintWithNum:(NSInteger)num;
@end
