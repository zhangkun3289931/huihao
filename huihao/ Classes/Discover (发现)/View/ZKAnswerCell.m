//
//  ZKAnswerCell.m
//  huihao
//
//  Created by 张坤 on 15/12/1.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKAnswerCell.h"
#import "MBProgressHUD+MJ.h"
#import "ZKCommonCellButton.h"
@interface ZKAnswerCell ()
/** 容器*/
@property (nonatomic,strong) UIView *topicView;
/** 发表评论的用户名*/
@property (nonatomic,strong) UILabel *userNameLB;
/** 问*/
@property (nonatomic,strong) UILabel *questionLB;
/** 发表评论的用户头像*/
@property (nonatomic,strong) UIImageView *userIcon;
/** 是否解决*/
@property (nonatomic,strong) UIImageView *isSeloveIV;
/** 发表评论的时间*/
@property (nonatomic,strong) UILabel *userTimeLB;
/** 发表评论的评论数*/
@property (nonatomic,strong) UILabel *userCountLB;
/** 发表评论的内容*/
@property (nonatomic,strong) UILabel *userContentLB;

/** 赞*/
@property (nonatomic,strong) ZKCommonCellButton *zhanBtn;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *secondlineView;


@end
@implementation ZKAnswerCell

- (void)awakeFromNib {
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"answerCell";
    ZKAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZKAnswerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *topicViewLB=[[UIView alloc]init];
        topicViewLB.backgroundColor = HuihaoBG;
        self.topicView = topicViewLB;
        [self.contentView addSubview:self.topicView];
        
        UILabel *userNameLB=[[UILabel alloc]init];
        //userNameLB.backgroundColor=[UIColor blackColor];
        userNameLB.font=TopNameFont;
        self.userNameLB=userNameLB;
        [self.topicView addSubview: self.userNameLB];
        
        UIImageView  *isSeloveIV=[[UIImageView alloc]init];
        isSeloveIV.frame=CGRectMake(self.width-(TopicMargin+UIScerrenSolveWH*2.4),0, UIScerrenSolveWH, UIScerrenSolveWH);
        isSeloveIV.contentMode = UIViewContentModeScaleAspectFit;
        [isSeloveIV setImage:[UIImage imageNamed:@"adopt"]];

        self.isSeloveIV=isSeloveIV;
        [self.topicView addSubview:self.isSeloveIV];
        
        
        UILabel *questionLB=[[UILabel alloc]init];
        questionLB.font=TopNameFont;
        questionLB.textColor=HuihaoRedBG;
        questionLB.text=@"答:";
        self.questionLB=questionLB;
        //[self.topicView addSubview: self.questionLB];
        
        
        UIImageView  *userIcon=[[UIImageView alloc]init];
        userIcon.frame = CGRectMake(TopicMargin, TopicMargin, UIScerrenIconWH, UIScerrenIconWH);
        userIcon.layer.cornerRadius = userIcon.width*0.5;
        userIcon.layer.borderWidth = 2;
        userIcon.layer.borderColor = TabBottomTextSelectColor.CGColor;
        userIcon.layer.masksToBounds = YES;
        self.userIcon = userIcon;
        [self.topicView addSubview:self.userIcon];
        
        
        UILabel *userTimeLB = [[UILabel alloc]init];
        userTimeLB.textColor = [UIColor grayColor];
        userTimeLB.font = TopTimeFont;
        self.userTimeLB = userTimeLB;
        [self.topicView addSubview:userTimeLB];
        
        UILabel *userCountLB = [[UILabel alloc]init];
        userCountLB.font = TopNameFont;
        self.userCountLB = userCountLB;
        
        UILabel *userContentLB = [[UILabel alloc]init];
        userContentLB.font = TopContentFont;
        userContentLB.numberOfLines = 0;
        userContentLB.textColor = HuihaoBingTextColor;
        self.userContentLB = userContentLB;
        [self.topicView addSubview:userContentLB];
        
        
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor whiteColor];
        self.lineView = lineView;
        
        UIView *secondlineView=[[UIView alloc]init];
        secondlineView.backgroundColor=ZKColor(208, 208, 208);
        self.secondlineView=secondlineView;
        [self.topicView addSubview:self.secondlineView];
        
        UIButton *caiNaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [caiNaBtn setTitle:@"采纳回复" forState:UIControlStateNormal];
        [caiNaBtn setTitleColor:HuihaoRedBG forState:UIControlStateNormal];
        caiNaBtn.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        [caiNaBtn addTarget:self action:@selector(cainaAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topicView addSubview:caiNaBtn];
        self.caiNaBtn=caiNaBtn;
        
      
        ZKCommonCellButton *zanBtn=[ZKCommonCellButton buttonWithType:UIButtonTypeCustom];
        self.zhanBtn=zanBtn;
        [zanBtn addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topicView addSubview:zanBtn];

        
    }
    return self;
}
- (void)cainaAction:(UIButton *)button
{

    ZKUserModdel *userModel=[ZKUserTool user];
    
    if (userModel==NULL) {
        return;
    }
    
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"commentId":self.topic.commentId,
                           };
    
    [ZKHTTPTool POST: [NSString stringWithFormat:@"%@inter/wenzhang/addAdoptState.do",baseUrl] params:params success:^(id json) {
        NSString *state=[json objectForKey:@"state"];
        if (state.integerValue==0) {
            [self.delegate caiNaAnswer:self withButton:button];
          
        }
        
    }  failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}
- (void)zanAction:(ZKCommonCellButton *)button
{
    self.zhanBtn.enabled = NO;
    ZKUserModdel *userModel=[ZKUserTool user];
    if (self.topic.useState != 2) {
        [MBProgressHUD showSuccess:@"已赞"];
        return;
    }
    
    NSString *sessionId = userModel.sessionId;
    if (sessionId.length == 0) {
        sessionId = @"";
    }
    
    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"commentId":self.topic.commentId,
                           };
    
    [ZKHTTPTool POST: [NSString stringWithFormat:@"%@inter/wenzhang/addUseful.do",baseUrl] params:params success:^(id json) {
      NSString *state=[json objectForKey:@"state"];
        if (state.integerValue==0) {
           NSInteger useful =  self.topic.useful + 1;
            [self.zhanBtn setTitle:[NSString stringWithFormat:@"(%zd)",useful] forState:UIControlStateNormal];
            self.zhanBtn.enabled = NO;
             [MBProgressHUD showSuccess:@"点赞成功"];
        }
        
    }state:^(NSString *state) {
        if ([state isEqualToString:@"-106"]) {
            [self.delegate answerCellNoLogin:self];
            self.zhanBtn.enabled = YES;
            return ;
        }
    } failure:^(NSError *error) {
        self.zhanBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];

    
}
- (void)setTopic:(ZKTopicModel *)topic
{
    _topic=topic;
    
    [self.userIcon sd_setImageWithURL:topic.userImgUrl placeholderImage:[UIImage imageNamed:@"image_bg2"]];
    NSString *usetNameStr=topic.nickName;
    if (topic.anonymous) {
        usetNameStr=@"匿名用户";
    }
    CGSize userNameSize=[usetNameStr sizeWithFont:TopNameFont];
    CGFloat userX=CGRectGetMaxX(self.userIcon.frame)+TopicMargin;
    self.userNameLB.frame=(CGRect){{userX, TopicMargin},userNameSize};
    self.userNameLB.text=usetNameStr;
    
    self.questionLB.frame=CGRectMake(150, 2, 40, 20);
    
    NSString *timeTemp= [NSString stringWithFormat:@"%@",topic.creatTime];
    CGSize timeSize=[timeTemp sizeWithFont:TopTimeFont];
    self.userTimeLB.text = timeTemp;
    CGFloat timeX = self.width - (timeSize.width+TopicMargin);
    //CGFloat timeX=CGRectGetMaxX(self.userNameLB.frame)+TopicMargin;
    CGFloat timeY = TopicMargin;
    self.userTimeLB.frame = (CGRect){{timeX,timeY},timeSize};
    
    
    
    NSString *content= [NSString stringWithFormat:@"%@",topic.commentContent];
    
    self.userContentLB.text=content ;
    CGSize contentSize=[content sizeWithFont:TopContentFont maxW:self.width-(3*TopicMargin+UIScerrenIconWH)];
    CGFloat contenY =  TopicMargin + CGRectGetMaxY(self.userNameLB.frame);
    self.userContentLB.frame=(CGRect){{TopicMargin*2+UIScerrenIconWH,contenY},contentSize};
    
    
    
    CGFloat lineViewY=CGRectGetMaxY(self.userContentLB.frame)+TopicMargin;
    
    self.lineView.frame=CGRectMake(0, lineViewY,self.width, 2);
    self.secondlineView.frame=CGRectMake(0, lineViewY+30, self.width, 1);
    
    
    NSString *countStr=[NSString stringWithFormat:@"(%zd)",topic.useful];
    self.userCountLB.text = countStr;
   
    CGSize countSize=[countStr sizeWithFont:TopNameFont];
     countSize.width+=10;
    CGFloat countX=self.width-TopicMargin-countSize.width -40;
    CGFloat countY=CGRectGetMaxY(self.lineView.frame)+6;
    
    self.zhanBtn.frame=CGRectMake(countX, countY, countSize.width+30, countSize.height);// (CGRect){{countX,countY},countSize};
    [self.zhanBtn setTitle:countStr forState:UIControlStateNormal];
    
    self.caiNaBtn.frame=CGRectMake(32, CGRectGetMaxY(self.lineView.frame), 100, 30);
    
    if (topic.adoptState) {
      
        self.isSeloveIV.hidden = NO;
        self.topicView.backgroundColor = ZKColor(238, 253, 233);
        
    }else{
        self.topicView.backgroundColor = HuihaoBG;
        self.isSeloveIV.hidden = YES;
    }
    ZKUserModdel *model = [ZKUserTool user];
    
    if (![self.articleUserId isEqualToString:model.userId]) {
        self.caiNaBtn.hidden = YES;
    }else
    {
        if (topic.showAdopt) {
            self.caiNaBtn.hidden = YES;
        }else
        {
            self.caiNaBtn.hidden = NO;
        }
    }
    
    if (topic.useState !=2){
        self.zhanBtn.enabled = NO;
    }else
    {
        self.zhanBtn.enabled = YES;
    }
    
    topic.cellHeight=CGRectGetMaxY(self.secondlineView.frame);
    CGFloat topicViewX = TopicViewMargin;
    CGFloat topicViewY = TopicViewMargin;
    CGFloat topicViewH = topic.cellHeight;
    CGFloat topicViewW = self.width-(2*TopicViewMargin);
    self.topicView.frame = CGRectMake(topicViewX, topicViewY, topicViewW, topicViewH);
    
}

@end
