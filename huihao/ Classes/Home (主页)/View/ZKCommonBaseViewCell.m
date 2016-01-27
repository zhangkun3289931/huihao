//
//  ZKCommonBaseViewCell.m
//  huihao
//
//  Created by 张坤 on 16/1/21.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKCommonBaseViewCell.h"

@implementation ZKCommonBaseViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView  *originalView=[[UIView alloc]init];
        
        originalView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:originalView];
        self.originalView=originalView;
        
        /** 头像 */
        ZKRedioImageView *iconView=[[ZKRedioImageView alloc]init];
        self.iconView=iconView;
        iconView.layer.cornerRadius=zkMarginContentIconWH*0.5;
        iconView.layer.borderWidth=1;
        iconView.layer.masksToBounds = YES;
        
        [self.originalView addSubview:iconView];
        /** 姓名 */
        UILabel  *nameLabel=[[UILabel alloc]init];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.font=zkUserNameFont;
        nameLabel.numberOfLines = 0;
        //nameLabel.backgroundColor = ZKRandomColor;
        nameLabel.textColor=HuihaoBingTextColor;
        self.nameLabel=nameLabel;
        [self.originalView addSubview:nameLabel];
        
        
        /** title */
        UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.originalView addSubview:titleBtn];
        titleBtn.titleLabel.font = zkTitleFont;
        [titleBtn addTarget:self action:@selector(bingClick:) forControlEvents:UIControlEventTouchDown];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.numberOfLines = 2;
        self.titleBtn = titleBtn;
        
        /** 患者类型 */
        ZKRedioLabel *typeLabel=[[ZKRedioLabel alloc]init];
        self.typeLabel=typeLabel;
        typeLabel.textAlignment=NSTextAlignmentCenter;
        typeLabel.font=zkTitleFont;
        typeLabel.textColor=[UIColor whiteColor];
        [self.originalView addSubview:typeLabel];
        /** 挂号途径 */
        UILabel *guahuaoLabel=[[UILabel alloc]init];
        guahuaoLabel.font=zkFont;
        self.guahuaoLabel=guahuaoLabel;
        guahuaoLabel.textColor=HuihaoBingTextColor;
        [self.originalView addSubview:guahuaoLabel];
        /** 诊断时间 */
        UILabel *zhenTimeLabel=[[UILabel alloc]init];
        zhenTimeLabel.font=zkFont;
        zhenTimeLabel.textColor=HuihaoBingTextColor;
        self.zhenTimeLabel=zhenTimeLabel;
        [self.originalView addSubview:zhenTimeLabel];
        /** 饭菜可口 */
        UILabel *zhenFancai=[[UILabel alloc]init];
        zhenFancai.font=zkFont;
        zhenFancai.textColor=HuihaoBingTextColor;
        self.zhenFanCai=zhenFancai;
        [self.originalView addSubview:zhenFancai];
        
        /** 整体评分 */
        UILabel *bodyScoreLabel=[[UILabel alloc]init];
        bodyScoreLabel.font=zkFont;
        bodyScoreLabel.textColor=HuihaoRedBG;
        self.bodyScoreLabel=bodyScoreLabel;
        [self.originalView addSubview:bodyScoreLabel];
        /** 环境条件 */
        UILabel *environmentConditionLabel=[[UILabel alloc]init];
        environmentConditionLabel.font=zkFont;
        environmentConditionLabel.textColor=HuihaoBingTextColor;
        self.environmentConditionLabel=environmentConditionLabel;
        [self.originalView addSubview:environmentConditionLabel];
        /** 医生诊疗 */
        UILabel *dictorLabel=[[UILabel alloc]init];
        dictorLabel.font=zkFont;
        dictorLabel.textColor=HuihaoBingTextColor;
        self.dictorLabel=dictorLabel;
        [self.originalView addSubview:dictorLabel];
        /** 报告结果 */
        UILabel *resultLabel=[[UILabel alloc]init];
        resultLabel.font=zkFont;
        resultLabel.textColor=HuihaoBingTextColor;
        self.resultLabel=resultLabel;
        [self.originalView addSubview:resultLabel];
        /** 门诊流程 */
        UILabel *menZhenProcessLabel=[[UILabel alloc]init];
        menZhenProcessLabel.font=zkFont;
        menZhenProcessLabel.textColor=HuihaoBingTextColor;
        self.menZhenProcessLabel=menZhenProcessLabel;
        [self.originalView addSubview:menZhenProcessLabel];
        /** 门诊药品费用 */
        UILabel *menZhenYaoFreeLabel=[[UILabel alloc]init];
        menZhenYaoFreeLabel.font=zkFont;
        menZhenYaoFreeLabel.textColor=HuihaoBingTextColor;
        self.menZhenYaoFreeLabel=menZhenYaoFreeLabel;
        [self.originalView addSubview:menZhenYaoFreeLabel];
        /** 门诊检查费用 */
        UILabel *menZhenJianFreeLabel=[[UILabel alloc]init];
        menZhenJianFreeLabel.font=zkFont;
        menZhenJianFreeLabel.textColor=HuihaoBingTextColor;
        self.menZhenJianFreeLabel=menZhenJianFreeLabel;
        [self.originalView addSubview:menZhenJianFreeLabel];
        /** 症状描述 */
        UILabel *zhenDescribeLabel=[[UILabel alloc]init];
        zhenDescribeLabel.font=zkFont;
        zhenDescribeLabel.textColor=HuihaoBingTextColor;
        zhenDescribeLabel.numberOfLines=0;
        self.zhenDescribeLabel=zhenDescribeLabel;
        [self.originalView addSubview:zhenDescribeLabel];
        
        UIImageView *contentIcon = [[UIImageView alloc]init];
        contentIcon.image = [UIImage imageNamed:@"account_checkinfo"];
        contentIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.contentIcon = contentIcon;
        [self.originalView addSubview:contentIcon];
        
        
        /** 正文 */
        UILabel *contentLabel=[[UILabel alloc]init];
        contentLabel.numberOfLines=0;
        contentLabel.font= [UIFont systemFontOfSize:12.0];
        contentLabel.textColor=HuihaoTextColor;
        self.contentLabel=contentLabel;
        [self.originalView addSubview:contentLabel];
        
     
        /** 时间 */
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font=zkTimeFont;
        self.timeLabel=timeLabel;
        [self.originalView addSubview:timeLabel];
        
       
        /** 有用 */
        ZKCommonCellButton *youyongButton=[ZKCommonCellButton buttonWithType:UIButtonTypeCustom];
        [youyongButton setTitle:@"有用 " forState:UIControlStateNormal];
        [youyongButton addTarget:self action:@selector(yongyongAction:) forControlEvents:UIControlEventTouchUpInside];
        self.youyongButton = youyongButton;
        [self.originalView addSubview:youyongButton];
        
        UIView *leftLine = [[UIView alloc]init];
        leftLine.backgroundColor= ZKColor(208, 208, 208);
        [self.originalView addSubview:leftLine];
        self.leftLine=leftLine;
        
        UIView *rightLine = [[UIView alloc]init];
        rightLine.backgroundColor= ZKColor(208, 208, 208);;
        [self.originalView addSubview:rightLine];
        self.rightLine=rightLine;
    }
    return self;
}

- (void)bingClick :(UIButton *)button {
  
}
- (void)yongyongAction:(ZKCommonCellButton *)btn
{
    self.youyongButton.enabled=NO;
}
@end
