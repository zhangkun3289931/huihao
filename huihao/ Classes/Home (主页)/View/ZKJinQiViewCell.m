//
//  ZKJinQiViewCell.m
//  huihao
//
//  Created by Alex on 15/9/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKJinQiViewCell.h"
@interface ZKJinQiViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *JJIcon;
@property (weak, nonatomic) IBOutlet UILabel *JJName;
@property (weak, nonatomic) IBOutlet UIImageView *JJImaged;
@property (weak, nonatomic) IBOutlet UILabel *JJType;
@property (weak, nonatomic) IBOutlet UILabel *JJTime;
@property (weak, nonatomic) IBOutlet UILabel *JJText;
@property (weak, nonatomic) IBOutlet UILabel *JJTextRight;
@property (strong, nonatomic) IBOutlet UIImageView *regionImageView;

@end
@implementation ZKJinQiViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
{
    //可充用标识符
    static NSString *ID=@"jinqiCell";
    
    ZKJinQiViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKJinQiViewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)awakeFromNib
{

    self.JJIcon.layer.cornerRadius=zkMarginContentIconWH*0.5;
    self.JJIcon.layer.borderWidth=1;
    self.JJIcon.layer.borderColor=LVColor.CGColor;
    self.JJIcon.layer.masksToBounds = YES;
    
}
- (void)setJinQiModel:(ZKJinQiModel *)jinQiModel
{
    _jinQiModel=jinQiModel;
    [self.JJIcon sd_setImageWithURL:[NSURL URLWithString:jinQiModel.userImgUrl] placeholderImage:[UIImage imageNamed:@"image_bg"]];
    [self.JJImaged sd_setImageWithURL:[NSURL URLWithString:jinQiModel.flagImgUrl] placeholderImage:[UIImage imageNamed:@"image_bg"]];
    self.JJName.text=jinQiModel.realName;
    
    if(jinQiModel.realName.length == 0){
        self.JJName.text = jinQiModel.userName;
    }

     self.JJType.text=@"默认锦旗";
    
    
    self.JJText.font = [UIFont systemFontOfSize:10.0];
    self.JJTextRight.font = [UIFont systemFontOfSize:10.0];
    
    if (jinQiModel.flagContent.length==10) {
        self.JJText.font = [UIFont systemFontOfSize:8.0];
        self.JJTextRight.font = [UIFont systemFontOfSize:8.0];
    }
    
    self.JJText.text=@"";
    self.JJTextRight.text=@"";
    self.JJType.backgroundColor=ShenLVColor;
    
    self.regionImageView.hidden = YES;
    
    
    if (jinQiModel.isDIY){
        self.JJType.text=@"自制锦旗";
        self.regionImageView.hidden = NO;
        self.JJType.backgroundColor=ShenFenColor;
        NSInteger conetntLength=jinQiModel.flagContent.length*0.5;
        self.JJText.text=[jinQiModel.flagContent substringToIndex:conetntLength];
        NSLog(@"%@",[jinQiModel.flagContent substringToIndex:jinQiModel.realName.length*0.5]);
         self.JJTextRight.text=[jinQiModel.flagContent substringFromIndex:conetntLength];
    }
    self.JJTime.text=jinQiModel.creatTime;
}


@end
