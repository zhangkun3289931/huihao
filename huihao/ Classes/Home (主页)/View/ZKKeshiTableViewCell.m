//
//  ZKKeshiTableViewCell.m
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKKeshiTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ZKKeshiTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *keshiName;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeader;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *MenZhenScore;
@property (weak, nonatomic) IBOutlet UILabel *ZhuYuanScore;
@property (weak, nonatomic) IBOutlet UILabel *ZhongHeScore;
- (IBAction)pingJiaBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *keshjiButton;
@end
@implementation ZKKeshiTableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"keshiCell";
    
    ZKKeshiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKKeshiTableViewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setKeshiModel:(ZKKeShiModel *)keshiModel
{
    _keshiModel=keshiModel;
    
    self.titleName.text=keshiModel.hospitalName;
    [self.imageHeader sd_setImageWithURL:[NSURL URLWithString:keshiModel.imgUrl]];
    self.keshiName.text=keshiModel.departmentTypeName;
    
    self.MenZhenScore.text=[NSString stringWithFormat:@"门诊评价:%@分 %@人评",keshiModel.zhenFeeling,keshiModel.zhenUserAmount];

    
    self.ZhuYuanScore.text=[NSString stringWithFormat:@"住院评价:%@分 %@人评",keshiModel.yuanFeeling,keshiModel.yuanUserAmount];

    
    self.ZhongHeScore.text=[NSString stringWithFormat:@"综合评价:%@分 %@人评",keshiModel.totalFeeling,keshiModel.totalUserAmount];
   
}
- (void)awakeFromNib {
        self.imageHeader.contentMode = UIViewContentModeScaleToFill & UIViewContentModeTop;
}


- (IBAction)pingJiaBtn:(UIButton *)sender {
    
    [self.delegate keShiTableViewCellWithClick:self button:sender];
}
@end
