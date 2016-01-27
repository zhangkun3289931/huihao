//
//  ZKDoctorTableViewCell.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKDoctorTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ZKDoctorTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *doctorIcon;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (strong, nonatomic) IBOutlet UILabel *dutyLabel;

@property (weak, nonatomic) IBOutlet UILabel *keshiLa;
@property (weak, nonatomic) IBOutlet UILabel *yunaLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *MeiLiZhi;
- (IBAction)pingJiaBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *doctionButton;

@end

@implementation ZKDoctorTableViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"doctorCell";
    
    ZKDoctorTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKDoctorTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setDoctorModel:(ZKDoctorModel *)doctorModel
{
    _doctorModel = doctorModel;
    if (!doctorModel) {
        return;
    }
    [self.doctorIcon sd_setImageWithURL:[NSURL URLWithString:doctorModel.imageName] placeholderImage:[UIImage imageNamed:@"image_bg"]];
    self.doctorName.text = doctorModel.doctorName;
    self.dutyLabel.text = doctorModel.position;
    
    self.keshiLa.text = doctorModel.departmentName;
    self.yunaLabel.text = doctorModel.hospitalName;
    self.scoreLabel.text = [NSString stringWithFormat:@"评分:%@分  %@人评",doctorModel.totalScore,doctorModel.revalueNum];
    self.MeiLiZhi.text = doctorModel.smartValue;
}

- (void)awakeFromNib {
    // Initialization code

    
    self.doctorIcon.contentMode = UIViewContentModeScaleToFill & UIViewContentModeTop;
    
    self.doctorIcon.layer.cornerRadius = self.doctorIcon.width*0.5;
    self.doctorIcon.layer.borderWidth = ImageBorderWidth;
    self.doctorIcon.layer.borderColor = [UIColor colorWithRed:0.600 green:0.827 blue:0.957 alpha:1.000].CGColor;
    self.doctorIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pingJiaBtn:(UIButton *)sender {
    [self.delegate doctorTableViewCellWithClick:self button:sender];
}
@end
