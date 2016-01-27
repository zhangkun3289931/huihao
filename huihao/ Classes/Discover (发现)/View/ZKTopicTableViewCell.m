//
//  ZKTopicTableViewCell.m
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKTopicTableViewCell.h"
#import "NSString+Extension.h"
#import "ZKStatusPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "ZKCommonModel.h"
#import "UIImageView+WebCache.h"
#import "ZKBingScrollerView.h"

@interface ZKTopicTableViewCell() <ZKStatusPhotoViewDelegate>
/** 容器*/
@property (nonatomic,strong) UIView *topicView;
/** 发表评论的用户名*/
@property (nonatomic,strong) UILabel *userNameLB;
/** 问*/
@property (nonatomic,strong) UILabel *questionLB;
/** scrollerlist*/
@property (nonatomic,strong) ZKBingScrollerView *tagListSV;
/** 发表评论的用户头像*/
@property (nonatomic,strong) UIImageView *userIcon;

/** 发表评论的时间*/
@property (nonatomic,strong) UILabel *userTimeLB;
/** 发表评论的评论数*/
@property (nonatomic,strong) UIButton *userCountLB;
/** 发表评论的内容*/
@property (nonatomic,strong) UILabel *userContentLB;/** 发表评论的用户名*/


/** 发表评论的照片*/
@property (nonatomic,strong) ZKStatusPhotoView *photoView;
@property (nonatomic,strong) UIView *secondlineView;

@property (nonatomic,strong) UIView *relpyView;

@end
@implementation ZKTopicTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"topicCell";
    ZKTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZKTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        self.topicView=topicViewLB;
        [self.contentView addSubview:self.topicView];
        
        UILabel *userNameLB=[[UILabel alloc]init];
        userNameLB.font=TopNameFont;
        self.userNameLB=userNameLB;
        [self.topicView addSubview: self.userNameLB];
        
  
        
        
        UILabel *questionLB=[[UILabel alloc]init];
        //userNameLB.backgroundColor=[UIColor blackColor];
        questionLB.font=TopNameFont;
        questionLB.text=@"问:";
        self.questionLB=questionLB;
       // [self.topicView addSubview: self.questionLB];
        
        
        UIImageView  *userIcon=[[UIImageView alloc]init];
        userIcon.frame=CGRectMake(TopicMargin, TopicMargin, UIScerrenIconWH, UIScerrenIconWH);
        userIcon.layer.cornerRadius = userIcon.width * 0.5;
        userIcon.layer.borderWidth = 2;
        userIcon.layer.borderColor = TabBottomTextSelectColor.CGColor;
        userIcon.layer.masksToBounds = YES;
        self.userIcon = userIcon;
        [self.topicView addSubview:self.userIcon];
        
        
        UILabel *userTimeLB=[[UILabel alloc]init];
        userTimeLB.textColor=[UIColor grayColor];
        userTimeLB.font=TopTimeFont;
        self.userTimeLB=userTimeLB;
        [self.topicView addSubview:userTimeLB];
        
        UIButton *userCountLB=[UIButton buttonWithType:UIButtonTypeCustom];
        self.userCountLB=userCountLB;
        userCountLB.enabled = YES;
        userCountLB.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [userCountLB setImage:[UIImage imageNamed:@"answer_mark"] forState:UIControlStateNormal];
        [userCountLB setBackgroundImage:[UIImage imageNamed:@"answer_bg"] forState:UIControlStateNormal];
        userCountLB.titleLabel.font = TopNameFont;
        [userCountLB setTitleColor:HuihaoBingTextColor forState:UIControlStateNormal];
        userCountLB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        userCountLB.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 10);
        userCountLB.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 5);
        userCountLB.adjustsImageWhenDisabled = NO;
        userCountLB.enabled = NO;
        
        [self.topicView addSubview:self.userCountLB];
        
        UILabel *userContentLB=[[UILabel alloc]init];
        userContentLB.font = TopContentFont;
        userContentLB.textColor = HuihaoBingTextColor;
        userContentLB.numberOfLines = 0;
         self.userContentLB = userContentLB;
        [self.topicView addSubview:userContentLB];
        
        ZKStatusPhotoView *photoView=[[ZKStatusPhotoView alloc]init];
        photoView.delegate = self;
        [self.topicView addSubview:photoView];
        self.photoView = photoView;
        
        UIView *secondlineView=[[UIView alloc]init];
        secondlineView.backgroundColor = HuihaoBG;
        self.secondlineView = secondlineView;
        [self.topicView addSubview:self.secondlineView];
        
        ZKBingScrollerView *tagListSV=[[ZKBingScrollerView alloc]init];
        self.tagListSV = tagListSV;
        [self.topicView addSubview:self.tagListSV];
        
        
        UIImageView  *isSeloveIV=[[UIImageView alloc]init];
        isSeloveIV.frame = CGRectMake(self.width-(TopicMargin+UIScerrenSolveWH*2.6),0, UIScerrenSolveWH, UIScerrenSolveWH);
        [isSeloveIV setImage:[UIImage imageNamed:@"solved"]];
        self.isSeloveIV = isSeloveIV;
        [self.topicView addSubview:self.isSeloveIV];
        
    }
    return self;
}
- (void)setTopic:(ZKTopicModel *)topic
{
    _topic=topic;
    
    [self.userIcon sd_setImageWithURL:topic.userImgUrl placeholderImage:[UIImage imageNamed:@"image_bg2"]];
    NSString *usetNameStr=topic.nickName;
    NSLog(@"%@",topic.nickName);
    if (topic.nickName.length==0) {
        usetNameStr = [topic.userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    if (topic.anonymous) {
        usetNameStr=@"匿名用户";
    }
    if (!self.topic.solveState){
        self.isSeloveIV.hidden=YES;
    }else{
        self.isSeloveIV.hidden=NO;
    }
    
    CGSize userNameSize=[usetNameStr sizeWithFont:TopNameFont];
    CGFloat userX=CGRectGetMaxX(self.userIcon.frame)+TopicMargin;
    self.userNameLB.frame=(CGRect){{userX, TopicMargin},userNameSize};
    
    self.userNameLB.text=usetNameStr;
    
    self.questionLB.frame=CGRectMake(150, 2, 40, 20);
    
    NSString *timeTemp= [NSString stringWithFormat:@"%@",topic.creatTime];
    self.userTimeLB.text=timeTemp;
    CGSize timeSize=[timeTemp sizeWithFont:TopTimeFont];
    CGFloat timeX= self.width - (timeSize.width+10);
    CGFloat timeY = TopicMargin;

    self.userTimeLB.frame=(CGRect){{timeX,timeY},timeSize};
    
    NSString *content= [NSString stringWithFormat:@"%@",topic.articleContent];
    
    self.userContentLB.text=content ;
    CGSize contentSize=[content sizeWithFont:TopContentFont maxW:self.width-(3*TopicMargin+UIScerrenIconWH)];
    CGFloat contenY=CGRectGetMaxY(self.userNameLB.frame) + 5;
    self.userContentLB.frame=(CGRect){{TopicMargin*2+UIScerrenIconWH,contenY},contentSize};
 
   
   
    CGFloat lineViewY;
    if (topic.imgList.count==0) {
        self.photoView.hidden=YES;
      ;
        lineViewY=CGRectGetMaxY(self.userContentLB.frame)+TopicMargin;
    }else
    {
        self.photoView.hidden=NO;
        self.photoView.photos=topic.imgList;
        CGSize photoSize=[ZKStatusPhotoView sizeWithPhontCount:topic.imgList.count];
        CGFloat photoX=TopicMargin*2+UIScerrenIconWH;
        CGFloat photoY=CGRectGetMaxY(self.userContentLB.frame)+5;
        
        self.photoView.frame=CGRectMake(photoX,photoY,photoSize.width, photoSize.height);
        lineViewY=CGRectGetMaxY(self.photoView.frame)+TopicMargin;
    }
    
    self.tagListSV.frame=CGRectMake(userX, lineViewY, self.width, 20.0);
    self.tagListSV.tagList=topic.tagList;
    
    NSString *countStr=[NSString stringWithFormat:@"%@人回复",topic.commentCount];
    [self.userCountLB setTitle:countStr forState:UIControlStateNormal];
    CGFloat countWidth = self.width - CGRectGetMinX(self.userNameLB.frame) -10;
    CGFloat countHeight = 30;
    CGFloat countX = CGRectGetMinX(self.userNameLB.frame);
    CGFloat countY=  CGRectGetMaxY(self.tagListSV.frame) + 5;
    self.userCountLB.frame= CGRectMake(countX, countY, countWidth, countHeight);
    
    
    self.secondlineView.frame=CGRectMake(0, CGRectGetMaxY(self.userCountLB.frame)+5, self.width ,1.0);

    
    topic.cellHeight=CGRectGetMaxY(self.secondlineView.frame)-1;
    
    CGFloat topicViewX = TopicViewMargin * 2;
    CGFloat topicViewY = TopicViewMargin;
    CGFloat topicViewH = topic.cellHeight;
    
    CGFloat topicViewW=self.width-(2*TopicViewMargin);
    
    self.topicView.frame=CGRectMake(topicViewX, topicViewY, topicViewW, topicViewH);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    for (NSDictionary *dict in self.topic.imgList) {
        
        NSString *imagePath= dict[@"imgUrl"];
        NSString *imgChuPath=[imagePath stringByReplacingOccurrencesOfString:@"_small." withString:@"."];
        MJPhoto *p=[[MJPhoto alloc]init];
        p.url = [NSURL URLWithString:imgChuPath];
        
        [arrayM addObject:p];
        index++;
    }
    
    //2. 相册显示
     MJPhotoBrowser *phVC=[[MJPhotoBrowser alloc]init];
    phVC.photos =arrayM;
    phVC.currentPhotoIndex=[indexPath integerValue] % arrayM.count;
    [phVC show];
}
@end
