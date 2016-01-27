//
//  ZKCommonHeaderView.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKKeShiModel.h"
#import "ZKDoctorModel.h"
#import "ZKKeShiCommonModel.h"
#import "ZKKeShiDetialModel.h"
@class ZKCommonHeaderView;
@protocol ZKCommonHeaderViewDelegate <NSObject>
@optional
- (void)commonHeaderButtonClick:(ZKCommonHeaderView *)common ;
- (void)commonHeaderJnqiButtonClick:(ZKCommonHeaderView *)common ;
@end
@interface ZKCommonHeaderView : UIView
+ (instancetype)commonHeaderView;
@property (nonatomic,strong) ZKKeShiModel *keshiModel;
@property (nonatomic,assign) NSInteger cornCount;
@property (nonatomic,strong) NSString *hospitalBrief;
@property (nonatomic,strong) ZKDoctorModel *doctorModel;
@property (nonatomic,strong) ZKKeShiCommonModel *commonModel;
@property (nonatomic,weak) id<ZKCommonHeaderViewDelegate> delegate;
@property (nonatomic,strong) ZKKeShiDetialModel *keshiDetialModel;
@end
