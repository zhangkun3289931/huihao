//
//  ZKForeButtonView.h
//  huihao
//
//  Created by Alex on 15/9/23.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZKForeButtonView;
@protocol ZKForeButtonViewrDelegate <NSObject>
- (void)foreButtonView:(ZKForeButtonView *)toolBar clickButton:(UIButton *)button type:(NSString *)type;
@end
@interface ZKForeButtonView : UIView
+ (instancetype)toolbar;
@property (nonatomic,strong) NSArray *models;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,weak) id<ZKForeButtonViewrDelegate> delegate;
@end
