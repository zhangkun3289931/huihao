//
//  ZKTopicModel.h
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKBaseModel.h"
@interface ZKTopicModel : ZKBaseModel
/** 用户ID*/
@property (nonatomic,copy) NSString *userId;
/** 图片地址*/
@property (nonatomic,copy) NSArray *imgList;
@property (nonatomic,strong) NSURL *userImgUrl;
/** 评论标题*/
@property (nonatomic,copy) NSString *articleTitle;
/** 是否匿名  1＝匿名*/
@property (nonatomic,assign) BOOL anonymous;
/** 话题内容*/
@property (nonatomic,copy) NSString *articleContent;
/** 评论内容*/
@property (nonatomic,copy) NSString *commentContent;
/** 评论id*/
@property (nonatomic,copy) NSString *articleId;
/** 评论数*/
@property (nonatomic,copy) NSString *commentCount;
/** 采纳状态 0 没有  1有*/
@property (nonatomic,assign) BOOL adoptState;
/** 是否显示 采纳状态 0 没有  1有*/
@property (nonatomic,assign) BOOL showAdopt;
/** 是否解决状态 0 没有  1有*/
@property (nonatomic,assign) BOOL  solveState;
/** 评论数*/
@property (nonatomic,assign) NSInteger type;
/** 评论数*/
/** 病种list*/
@property (nonatomic,strong) NSArray *tagList;
/** 评论id*/
@property (nonatomic,copy) NSString  *commentId;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;



@end
