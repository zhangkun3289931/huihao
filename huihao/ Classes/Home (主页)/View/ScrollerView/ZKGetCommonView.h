//
//  ZKGetCommonView.h
//  huihao
//
//  Created by 张坤 on 15/10/12.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKIMageModel.h"
@class ZKGetCommonView;
@protocol ZKZKGetCommonViewDelegate <NSObject>
- (void)foreButtonView:(ZKGetCommonView *)toolBar clickButton:(UIButton *)button type:(NSString *)type;
@end

@interface ZKGetCommonView : UIView
@property (nonatomic,strong) NSArray *models;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,weak) id<ZKZKGetCommonViewDelegate> delegate;
@end
