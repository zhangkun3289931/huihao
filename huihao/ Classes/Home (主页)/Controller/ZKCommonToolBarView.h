//
//  ZKCommonToolBarView.h
//  huihao
//
//  Created by 张坤 on 16/1/25.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCommentButton.h"
@class ZKCommonToolBarView;

@protocol ZKCommonToolBarViewDelegate <NSObject>

- (void)commonToolBarView:(ZKCommonToolBarView *)commonToolBarView withClickItem :(ZKCommentButton *)item;

@end

@interface ZKCommonToolBarView : UIView

+ (instancetype)commonToolBarView;

@property (nonatomic,strong) NSArray *toolBarTitles;
@property (nonatomic,copy) NSString *isAttention;
@property (nonatomic,weak) id<ZKCommonToolBarViewDelegate> delegate;
@end
