//
//  ZKCommonViewCell.m
//  huihao
//
//  Created by Alex on 15/9/17.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKCommonDepartmentViewCell.h"

@interface ZKCommonDepartmentViewCell() <ZKStatusPhotoViewDelegate>

@end
@implementation ZKCommonDepartmentViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"pingjiaCell";
    
    ZKCommonDepartmentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[ZKCommonDepartmentViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        /** 配图 */
        ZKStatusPhotoView *photosView = [[ZKStatusPhotoView alloc]init];
        photosView.delegate = self;
         [self.originalView addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

- (void)bingClick :(UIButton *)button {
    [super bingClick:button];
    
    if ([self.delegate respondsToSelector:@selector(commonViewCellBingClick:withBingName:)]) {
         [self.delegate commonViewCellBingClick:self withBingName:button.titleLabel.text];
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
    NSString *pjId=self.commentModel.yuanId;
    if ([self.commentModel.pjType isEqualToString:@"1"]) {
            pjId=self.commentModel.zhenId;
    }
    NSString *sessionId=userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@"";
    }
    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"pjId": pjId,
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
            [self.delegate commonViewCellNoLogin:self];
            return ;
        }
    } failure:^(NSError *error) {
        
    } ];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setCommentModel:(ZKCommentModel *)commentModel
{
    _commentModel=commentModel;
    self.iconView.frame=CGRectMake(zkMarginContentLeft, zkImagePaddingTop, zkMarginContentIconWH, zkMarginContentIconWH);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:commentModel.userImgUrl] placeholderImage:[UIImage imageNamed:@"image_bg"]];
    /** 姓名 */
    
    NSString *name = commentModel.nickName;
    if (name.length == 0) {
        name = commentModel.userName;
    }
    CGSize nameSize= [name sizeWithFont:zkUserNameFont maxW:zkMarginTitleNameW-20];
    self.nameLabel.frame=CGRectMake(zkMarginContentLeft-5,CGRectGetMaxY(self.iconView.frame)+zkMarginPaddingTop, zkMarginContentIconWH+10, nameSize.height+10);
    self.nameLabel.text=commentModel.nickName;
    
    /** title */
    CGFloat titleX=CGRectGetMaxX(self.iconView.frame)+zkMarginContentLeft;
    CGSize titleSize= [commentModel.diseaseName sizeWithFont:zkTitleFont maxW:zkMarginTitleNameW];

    self.titleBtn.frame=CGRectMake(titleX, zkImagePaddingTop, titleSize.width, zkMarginContentNameH);
    [self.titleBtn setTitle:commentModel.diseaseName forState:UIControlStateNormal];
    
    
    /** 患者类型 */
    self.typeLabel.frame=CGRectMake(self.width-zkTextFileW, zkImagePaddingTop,65, zkMarginContentNameH);

    /** 挂号途径 */
    CGFloat guahuaoY=CGRectGetMaxY(self.typeLabel.frame)+zkMarginPaddingTop;
    self.guahuaoLabel.frame=CGRectMake(self.width-zkTextFileW, guahuaoY, zkTextFileW, zkMarginContentNameH);
    
    /** 诊断时间 */
    CGFloat zhenTimeY=CGRectGetMaxY(self.guahuaoLabel.frame)+zkMarginPaddingTop;
    self.zhenTimeLabel.frame=CGRectMake(self.width-zkTextFileW, zhenTimeY, zkTextFileW, zkMarginContentNameH);
    
    /** 饭菜可口 */
    CGFloat zhenFanCaiY=CGRectGetMaxY(self.zhenTimeLabel.frame)+zkMarginPaddingTop;
    self.zhenFanCai.frame=CGRectMake(self.width-zkTextFileW, zhenFanCaiY, zkTextFileW, zkMarginContentNameH);
    self.zhenFanCai.text=[NSString stringWithFormat:@"饭菜可口: %@分",commentModel.taste];
    
    /** 整体评分 */
    CGFloat bodyScoreY=CGRectGetMaxY(self.titleBtn.frame)+zkMarginPaddingTop;
    self.bodyScoreLabel.frame=CGRectMake(titleX, bodyScoreY, zkMarginContentNameW, zkMarginContentNameH);
  
    /** 环境条件 */
    CGFloat environmentY=CGRectGetMaxY(self.bodyScoreLabel.frame)+zkMarginPaddingTop;
    self.environmentConditionLabel.frame=CGRectMake(titleX, environmentY, zkMarginContentNameW, zkMarginContentNameH);
    
    /** 医生诊疗 */
    CGFloat dictorY=CGRectGetMaxY(self.environmentConditionLabel.frame)+zkMarginPaddingTop;
    self.dictorLabel.frame=CGRectMake(titleX, dictorY, zkMarginContentNameW, zkMarginContentNameH);
    
    
    /** 报告结果 */
    CGFloat resultY=CGRectGetMaxY(self.dictorLabel.frame)+zkMarginPaddingTop;
    self.resultLabel.frame=CGRectMake(titleX, resultY, zkMarginContentNameW, zkMarginContentNameH);
    
    /** 门诊流程 */
    CGFloat menZhenY=CGRectGetMaxY(self.resultLabel.frame)+zkMarginPaddingTop;
    self.menZhenProcessLabel.frame=CGRectMake(titleX, menZhenY, zkMarginContentNameW, zkMarginContentNameH);
    
    /** 门诊药品费用 */
    CGFloat menZhenYaoFreeY=CGRectGetMaxY(self.menZhenProcessLabel.frame)+zkMarginPaddingTop;
    self.menZhenYaoFreeLabel.frame=CGRectMake(titleX, menZhenYaoFreeY, zkMarginContentNameW, zkMarginContentNameH);
    self.menZhenYaoFreeLabel.text=[NSString stringWithFormat:@"门诊药品费用:%@元",commentModel.zhenDrugCost];
    
    /** 门诊检查费用 */
    CGFloat menZhenJianFreeY=CGRectGetMaxY(self.menZhenYaoFreeLabel.frame)+zkMarginPaddingTop;
    self.menZhenJianFreeLabel.frame=CGRectMake(titleX, menZhenJianFreeY, zkMarginContentNameW, zkMarginContentNameH);
    self.menZhenJianFreeLabel.text=[NSString stringWithFormat:@"门诊检查费用:%@元",commentModel.zhenCheckCost];
  
    
    CGFloat zhenDescribeY;
    if ([commentModel.pjType isEqualToString:@"1"]) {
       // self.originalView.backgroundColor=QianFenColor;
        self.typeLabel.text=@"门诊患者";
        self.typeLabel.backgroundColor = ShenFenColor;
         self.iconView.layer.borderColor = ShenFenColor.CGColor;
          self.bodyScoreLabel.text=[NSString stringWithFormat:@"整体评分: %@分",commentModel.zhenFeeling];
        self.guahuaoLabel.text=[NSString stringWithFormat:@"挂号途径: %@",commentModel.guaWay];
        self.zhenTimeLabel.text=[NSString stringWithFormat:@"候诊时间: %@分钟",commentModel.waitTime];
        self.zhenFanCai.hidden=YES;
        self.environmentConditionLabel.text=[NSString stringWithFormat:@"环境条件: %@分",commentModel.envirement];
        self.dictorLabel.text=[NSString stringWithFormat:@"医生诊断: %@分钟",commentModel.treatTime];
        self.resultLabel.text=[NSString stringWithFormat:@"报告结果: %@",commentModel.recordWait];
        self.menZhenProcessLabel.text=[NSString stringWithFormat:@"门诊流程: %@",commentModel.zhenFlow];
        self.menZhenYaoFreeLabel.hidden=NO;
        self.menZhenJianFreeLabel.hidden=NO;
       zhenDescribeY=CGRectGetMaxY(self.menZhenJianFreeLabel.frame)+zkMarginPaddingTop;
        self.timeLabel.text=commentModel.zhenCreatTime;//@"2015-09-09 14:65:00";//
        
    }else if([commentModel.pjType isEqualToString:@"2"])
    {
        self.typeLabel.text=@"住院患者";
        //self.originalView.backgroundColor=QianLVColor;
        
        self.typeLabel.backgroundColor=LVColor;
        self.iconView.layer.borderColor=LVColor.CGColor;
        self.bodyScoreLabel.text=[NSString stringWithFormat:@"整体评分: %@分",commentModel.yuanFeeling];
        self.guahuaoLabel.text=[NSString stringWithFormat:@"住院天数: %@天",commentModel.yuanDay];
        self.zhenTimeLabel.text=[NSString stringWithFormat:@"护士服务: %@分",commentModel.nurseService];
        self.zhenFanCai.hidden=NO;
        self.environmentConditionLabel.text=[NSString stringWithFormat:@"主治治疗: %@分",commentModel.majorSkill];
        self.dictorLabel.text=[NSString stringWithFormat:@"病房环境: %@分",commentModel.environment];
        self.resultLabel.text=[NSString stringWithFormat:@"自费比例: %@%%",commentModel.operationCost];
        self.menZhenProcessLabel.text=[NSString stringWithFormat:@"住院总费用: %@元",commentModel.yuanCost];
        self.menZhenYaoFreeLabel.hidden=YES;
        self.menZhenJianFreeLabel.hidden=YES;
        zhenDescribeY=CGRectGetMaxY(self.menZhenProcessLabel.frame)+zkMarginPaddingTop;
         self.timeLabel.text=commentModel.yuanCreatTime;//@"2015-09-09 14:65:00";//
    }
    
    /** 症状描述 */
    NSString *zhenDecribeText = [NSString stringWithFormat:@"症状描述：%@", [commentModel.symptomDescription stringByReplacingOccurrencesOfString:@","
                                                             withString:@"\n                  "]];
    

    CGSize zhenDescribeSize= [zhenDecribeText sizeWithFont:zkFont maxW:zkContentW];
    self.zhenDescribeLabel.frame=CGRectMake(titleX, zhenDescribeY+zkMarginPaddingTop, zhenDescribeSize.width, zhenDescribeSize.height);
    self.zhenDescribeLabel.text = zhenDecribeText;
    
    /** 正文 */
    NSString *contentText = commentModel.zhenDescription;
    CGFloat photoY;
    
    if (contentText.length > 0) {
        self.contentLabel.hidden = NO;
        self.contentIcon.hidden  = NO;
        
        CGFloat contenY=CGRectGetMaxY(self.zhenDescribeLabel.frame)+zkMarginPaddingTop+5;
        CGSize contentSize= [contentText sizeWithFont:[UIFont systemFontOfSize:12.0] maxW:zkContentW];
        self.contentLabel.frame = CGRectMake(titleX + 20, contenY, contentSize.width, contentSize.height);
        self.contentLabel.text = contentText;
        
        self.contentIcon.frame = CGRectMake(titleX, contenY, 15, 15);
        
        
         photoY=CGRectGetMaxY(self.contentLabel.frame)+zkMarginPaddingTop+4;
    }else{
        self.contentLabel.hidden = YES;
        self.contentIcon.hidden  = YES;
        
         photoY=CGRectGetMaxY(self.zhenDescribeLabel.frame)+zkMarginPaddingTop+4;
        
    }
  
    CGFloat timeY;
    if (commentModel.imgList.count==0) {
        self.photosView.hidden=YES;
         timeY=CGRectGetMaxY(self.contentLabel.frame)+zkMarginPaddingTop;
        if (contentText.length==0) {
             timeY=CGRectGetMaxY(self.zhenDescribeLabel.frame);
        }
    }else
    {
        self.photosView.hidden=NO;
        CGSize photoSize=[ZKStatusPhotoView sizeWithPhontCount:commentModel.imgList.count];
        self.photosView.frame=CGRectMake(titleX, photoY, self.width-90, photoSize.height);
        self.photosView.photos=commentModel.imgList;
        
        timeY=CGRectGetMaxY(self.photosView.frame);
    }
    /** 时间 */
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
    
    CGFloat leftLineW = self.width * 0.5 - 4 * zkMarginContentLeft;
    CGFloat rightLineX = CGRectGetMaxX(self.youyongButton.frame);
     self.leftLine.frame=CGRectMake(zkMarginContentLeft, CGRectGetMaxY(self.timeLabel.frame)+14, leftLineW, zkLineHeight);
     self.rightLine.frame=CGRectMake(rightLineX, CGRectGetMaxY(self.timeLabel.frame)+14, leftLineW, zkLineHeight);
    
    self.originalView.frame=CGRectMake(zkMarginLeft, zkMarginTop, self.width-2*zkMarginLeft, CGRectGetMaxY(self.youyongButton.frame)+10);
 
    commentModel.cellHeight= CGRectGetMaxY(self.originalView.frame);
    
}
#pragma mark -照片浏览器的代理方法
- (void)ZKStatusPhotoView:(ZKStatusPhotoView *)statusPhotoView didSelectRowAtIndexPath:(NSString *)indexPath
{
    NSLog(@"%@",indexPath);
    [self showPhtot:indexPath];
}
#pragma mark -显示照片浏览器
- (void)showPhtot:(NSString *)indexPath
{

    NSMutableArray *arrayM=[NSMutableArray array];
    NSInteger index=0;
    for (NSDictionary *dict in self.commentModel.imgList) {
        
        NSString *imagePath= dict[@"imgUrl"];
        NSString *imgChuPath=[imagePath stringByReplacingOccurrencesOfString:@"_small." withString:@"."];
        MJPhoto *p=[[MJPhoto alloc]init];
        p.url = [NSURL URLWithString:imgChuPath];
        
        [arrayM addObject:p];
        index++;
    }
    
    //2. 相册显示
    MJPhotoBrowser *phVC= [[MJPhotoBrowser alloc]init];
    phVC.photos = arrayM;
    phVC.currentPhotoIndex= [indexPath integerValue] % arrayM.count;
    [phVC show];

}
@end
