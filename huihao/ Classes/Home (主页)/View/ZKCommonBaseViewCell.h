//
//  ZKCommonBaseViewCell.h
//  huihao
//
//  Created by 张坤 on 16/1/21.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKDoctorCommonModel.h"
#import "ZKCommentModel.h"
#import "UIImageView+WebCache.h"
#import "ZKRedioImageView.h"
#import "ZKRedioLabel.h"
#import "ZKStatusPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "MBProgressHUD+MJ.h"
#import "ZKCommonCellButton.h"
@interface ZKCommonBaseViewCell : UITableViewCell
/** 整体View*/
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) ZKRedioImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 标题 */
@property (nonatomic, weak) UIButton *titleBtn;
/** 患者类型 */
@property (nonatomic, weak) ZKRedioLabel *typeLabel;
/** 挂号途径 */
@property (nonatomic, weak) UILabel *guahuaoLabel;
/** 诊断时间 */
@property (nonatomic, weak) UILabel *zhenTimeLabel;
/** 诊断时间 */
@property (nonatomic, weak) UILabel *zhenFanCai;

/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 整体评分 */
@property (nonatomic, weak) UILabel *bodyScoreLabel;
/** 环境条件 */
@property (nonatomic, weak) UILabel *environmentConditionLabel;
/** 医生诊疗 */
@property (nonatomic, weak) UILabel *dictorLabel;
/** 报告结果 */
@property (nonatomic, weak) UILabel *resultLabel;
/** 门诊流程 */
@property (nonatomic, weak) UILabel *menZhenProcessLabel;
/** 门诊药品费用 */
@property (nonatomic, weak) UILabel *menZhenYaoFreeLabel;
/** 门诊检查费用 */
@property (nonatomic, weak) UILabel *menZhenJianFreeLabel;
/** 症状描述 */
@property (nonatomic, weak) UILabel *zhenDescribeLabel;

/** icon */
@property (nonatomic, weak) UIImageView *contentIcon;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 配图 */
@property (nonatomic, weak) ZKStatusPhotoView *photosView;
/** 有用按钮 */
@property (nonatomic, weak) ZKCommonCellButton *youyongButton;

@property (nonatomic, weak) UIView *leftLine;
@property (nonatomic, weak) UIView *rightLine;


- (void)bingClick :(UIButton *)button;
- (void)yongyongAction:(ZKCommonCellButton *)btn;
@end
