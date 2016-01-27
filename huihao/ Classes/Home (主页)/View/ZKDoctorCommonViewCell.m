//
//  ZKDoctorCommonViewCell.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDoctorCommonViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZKRedioLabel.h"
@interface ZKDoctorCommonViewCell()

@end
@implementation ZKDoctorCommonViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"doctorCommonCell";
    
    ZKDoctorCommonViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[ZKDoctorCommonViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
    }
    return self;
}

- (void)bingClick :(UIButton *)button {
    [super bingClick:button];
    if ([self.delegate respondsToSelector:@selector(doctorViewCellWithBingClick:bingName:)]) {
        [self.delegate doctorViewCellWithBingClick:self bingName:button.titleLabel.text];
    }
}

- (void)yongyongAction:(ZKCommonCellButton *)btn
{
    [super yongyongAction:btn];
    [self useClickButton:self.youyongButton];
}

- (void)useClickButton:(ZKCommonCellButton *)button
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionId=userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@""; 
    }
    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"pjId": self.commentModel.uuid,
                           @"pjType" :self.commentModel.pjType,
                           @"pjState":[NSString stringWithFormat:@"%zd",button.tag]
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/pingjia/addPingJiaR.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSInteger youyongCount=self.commentModel.useful;
        youyongCount++;
        [self.youyongButton setTitle:[NSString stringWithFormat:@"(%zd)",  youyongCount] forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"觉得这条不错"]];
        
    }state:^(NSString *state) {
        if ([state isEqualToString:@"-106"]) {
             self.youyongButton.enabled = YES;
            [self.delegate doctorViewCellNoLogin:self];
        }
    } failure:^(NSError *error) {
        self.youyongButton.enabled = YES;
        [MBProgressHUD showError:@"网络异常"];
    } ];
}

- (void)setCommentModel:(ZKDoctorCommonModel *)commentModel
{
    _commentModel=commentModel;
    if ([commentModel.pjType isEqualToString:@"3"]) {

        self.typeLabel.text=@"门诊患者";
        self.typeLabel.backgroundColor=ShenFenColor;
        self.iconView.layer.borderColor=ShenFenColor.CGColor;
        
        self.guahuaoLabel.text=[NSString stringWithFormat:@"问诊耐心: %@分",commentModel.greet];
        self.zhenTimeLabel.text=[NSString stringWithFormat:@"服药指导: %@分",commentModel.teach];
        self.bodyScoreLabel.text=[NSString stringWithFormat:@"整体评分: %@分",commentModel.totalMark];
        self.environmentConditionLabel.text=[NSString stringWithFormat:@"报告讲解: %@分",commentModel.report];
        self.dictorLabel.text=[NSString stringWithFormat:@"后续就诊帮助: 无"];
        if([commentModel.healthAfter isEqualToString:@"0"])
        {
             self.dictorLabel.text=[NSString stringWithFormat:@"后续就诊帮助: 有"];
        }
    }else if([commentModel.pjType isEqualToString:@"4"])
    {
        self.typeLabel.text=@"住院患者";
        
        self.typeLabel.backgroundColor=LVColor;
        self.iconView.layer.borderColor=LVColor.CGColor;
        
        self.guahuaoLabel.text=[NSString stringWithFormat:@"自感效果: %@分",commentModel.skill];
        self.zhenTimeLabel.text=[NSString stringWithFormat:@"治疗指导: %@分",commentModel.teach];
        self.bodyScoreLabel.text=[NSString stringWithFormat:@"整体评分: %@分",commentModel.totalMark];
        self.environmentConditionLabel.text=[NSString stringWithFormat:@"医生查房: %@分",commentModel.roundAttitude];
        
        self.dictorLabel.text=[NSString stringWithFormat:@"后续康复指导: 无"];
        if([commentModel.healthAfter isEqualToString:@"0"])
        {
            self.dictorLabel.text=[NSString stringWithFormat:@"后续康复指导: 有"];
        }
    }
    self.iconView.frame=CGRectMake(zkMarginContentLeft, zkImagePaddingTop, zkMarginContentIconWH, zkMarginContentIconWH);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:commentModel.userImageUrl] placeholderImage:[UIImage imageNamed:@"image_bg"]];
    /** name*/
    NSString *name = commentModel.nickName;
    if (name.length == 0) {
        name = commentModel.username;
    }
    
    CGSize nameSize = [name sizeWithFont:zkUserNameFont maxW:zkMarginTitleNameW-20];
    self.nameLabel.frame = CGRectMake(zkMarginContentLeft - 5,CGRectGetMaxY(self.iconView.frame)+zkMarginPaddingTop, zkMarginContentIconWH + 10, nameSize.height);
    self.nameLabel.text = name;
    
    /** title */
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame)+zkMarginContentLeft;
    CGSize titleSize= [commentModel.diseaseName sizeWithFont:zkTitleFont maxW:zkMarginTitleNameW];
    
    self.titleBtn.frame = CGRectMake(titleX, zkImagePaddingTop, titleSize.width, zkMarginContentNameH);
    [self.titleBtn setTitle:commentModel.diseaseName forState:UIControlStateNormal];//


    /** 患者类型 */
    self.typeLabel.frame=CGRectMake(self.width-zkTextFileW, zkImagePaddingTop, 65, zkMarginContentNameH);
    
    /** 问诊耐心 */
    CGFloat guahuaoY=CGRectGetMaxY(self.typeLabel.frame)+zkMarginPaddingTop;
    self.guahuaoLabel.frame=CGRectMake(self.width-zkTextFileW, guahuaoY, zkTextFileW, zkMarginContentNameH);
   
    /** 服药指导 */
    CGFloat zhenTimeY=CGRectGetMaxY(self.guahuaoLabel.frame)+zkMarginPaddingTop;
    self.zhenTimeLabel.frame=CGRectMake(self.width-zkTextFileW, zhenTimeY, zkTextFileW, zkMarginContentNameH);
   
    /** 整体感受 */
    CGFloat bodyScoreY=CGRectGetMaxY(self.titleBtn.frame)+zkMarginPaddingTop;
    self.bodyScoreLabel.frame=CGRectMake(titleX, bodyScoreY, zkMarginContentNameW, zkMarginContentNameH);
    
    /** 报告讲解 */
    CGFloat environmentY=CGRectGetMaxY(self.bodyScoreLabel.frame)+zkMarginPaddingTop;
    self.environmentConditionLabel.frame=CGRectMake(titleX, environmentY, zkMarginContentNameW, zkMarginContentNameH);

    /** 后续就诊帮助 */
    CGFloat dictorY=CGRectGetMaxY(self.environmentConditionLabel.frame)+zkMarginPaddingTop;
    self.dictorLabel.frame=CGRectMake(titleX, dictorY, zkMarginContentNameW, zkMarginContentNameH);
    
    /** 症状描述 */
    NSString *zhenDecribeText = [NSString stringWithFormat:@"症状描述：%@", [commentModel.symptom stringByReplacingOccurrencesOfString:@","
                                                                                                                                  withString:@"\n                  "]];
    
    CGFloat zhenDescribeY=CGRectGetMaxY(self.dictorLabel.frame)+zkMarginPaddingTop;
    CGSize zhenDescribeSize=[zhenDecribeText sizeWithFont:zkFont maxW:zkContentW];
    self.zhenDescribeLabel.frame=CGRectMake(titleX, zhenDescribeY, zhenDescribeSize.width, zhenDescribeSize.height);
    self.zhenDescribeLabel.text=zhenDecribeText;
    
    /** 正文 */
    CGFloat timeY;
    self.contentLabel.text=commentModel.des;
   
    if (self.contentLabel.text.length>0) {
        self.contentLabel.hidden = NO;
        self.contentIcon.hidden  = NO;
        
        CGFloat contenY=CGRectGetMaxY(self.zhenDescribeLabel.frame)+zkMarginPaddingTop+2;
        CGSize contentSize= [self.contentLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0] maxW:zkContentW];
        self.contentLabel.frame = CGRectMake(titleX + 20 , contenY, contentSize.width, contentSize.height);
        self.contentIcon.frame = CGRectMake(titleX, contenY, 15, 15);

        
        timeY=CGRectGetMaxY(self.contentLabel.frame)+zkMarginPaddingTop;
    }else{
        self.contentLabel.hidden = YES;
        self.contentIcon.hidden  = YES;
        timeY=CGRectGetMaxY(self.zhenDescribeLabel.frame)+zkMarginPaddingTop;
    }

    
    /** 时间 */
    
    self.timeLabel.text=commentModel.time;
    self.timeLabel.frame = CGRectMake(0, timeY,self.width - zkMarginContentLeft, zkMarginContentNameH);
    
    CGFloat zhanW=90;
    CGFloat zhanH=15;

    
    if(commentModel.useState==0)
    {
        self.youyongButton.enabled=NO;
    }else if(commentModel.useState==2)
    {
        self.youyongButton.enabled=YES;
    }
    [self.youyongButton setTitle:[NSString stringWithFormat:@"(%zd)",  commentModel.useful] forState:UIControlStateNormal];
    self.youyongButton.frame=CGRectMake((self.width-zhanW)*0.5, CGRectGetMaxY(self.timeLabel.frame)+5, zhanW, zhanH);
    
    CGFloat leftLineW = self.width *0.5 - 4*zkMarginContentLeft;
    CGFloat rightLineX = CGRectGetMaxX(self.youyongButton.frame);
    self.leftLine.frame=CGRectMake(zkMarginContentLeft, CGRectGetMaxY(self.timeLabel.frame)+14, leftLineW, 1);
    self.rightLine.frame=CGRectMake(rightLineX, CGRectGetMaxY(self.timeLabel.frame)+14, leftLineW, 1);

    
    CGFloat jjj=  CGRectGetMaxY(self.youyongButton.frame) +10;
    self.originalView.frame=CGRectMake(zkMarginLeft, zkMarginTop, self.width-2*zkMarginLeft, jjj);
    
    commentModel.cellHeight= jjj;
}
@end
