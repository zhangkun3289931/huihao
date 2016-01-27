//
//  ZKMyTopicViewCell.m
//  huihao
//
//  Created by 张坤 on 16/1/8.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKMyTopicViewCell.h"
#import "ZKStatusPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ZKMyTopicViewCell()<ZKStatusPhotoViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *topicContent;
@property (strong, nonatomic) IBOutlet UIImageView *topicSlove;
@property (strong, nonatomic) IBOutlet UILabel *topicNumReply;
@property (strong, nonatomic) IBOutlet UILabel *topicTime;
@property (strong, nonatomic) IBOutlet ZKStatusPhotoView *photoView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photoViewTop;

@property (strong, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZKMyTopicViewCell 

+(instancetype)tagCellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"focusCell";
    ZKMyTopicViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKMyTopicViewCell" owner:nil options:nil] lastObject];
        // 点击cell的时候不要变色
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
     self.photoView.delegate = self;
}

- (void)setTopicModel:(ZKTopicModel *)topicModel
{
    _topicModel = topicModel;
    
    self.topicContent.text = topicModel.articleContent;
    self.topicTime.text = topicModel.creatTime;
    self.topicNumReply.text = [NSString stringWithFormat:@"%@人回复",topicModel.commentCount];
    self.topicSlove.hidden = !topicModel.solveState;
    
    topicModel.cellHeight = 90;
}

@end
