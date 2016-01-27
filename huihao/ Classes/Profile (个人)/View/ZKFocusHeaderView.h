//
//  ZKFocusHeaderView.h
//  huihao
//
//  Created by 张坤 on 15/10/15.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKGroupModel.h"
@class ZKFocusHeaderView;
@protocol focusHeaderViewDelegate <NSObject>
@optional
- (void)regionController:(ZKFocusHeaderView*) region buttonType:(BOOL) isSelect;
@end
@interface ZKFocusHeaderView : UIView
@property (nonatomic,strong) NSString *key;
@property (nonatomic,assign) NSInteger sec;
@property (nonatomic, assign) NSInteger headerType;
@property (nonatomic,strong) ZKGroupModel *groupModel;
@property (nonatomic,weak) id<focusHeaderViewDelegate> delegate;
@end
