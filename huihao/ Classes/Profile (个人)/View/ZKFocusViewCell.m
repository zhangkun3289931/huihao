//
//  ZKFocusViewCell.m
//  huihao
//
//  Created by Alex on 15/9/29.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKFocusViewCell.h"
@interface ZKFocusViewCell()
- (IBAction)focusAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *focusName;
@property (weak, nonatomic) IBOutlet UILabel *focusKeshiName;
@property (strong, nonatomic) IBOutlet UILabel *doctorOfDeaprtmentName;

@end
@implementation ZKFocusViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"focusCell";
    ZKFocusViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKFocusViewCell" owner:nil options:nil] lastObject];
        // 点击cell的时候不要变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFocusModel:(ZKFocusModel *)focusModel
{
    _focusModel=focusModel;
    if (focusModel.type==2) {
         self.doctorOfDeaprtmentName.text = @" ";
        self.focusName.text=focusModel.hospitalName;
        self.focusKeshiName.text=[NSString stringWithFormat:@"%@",focusModel.departmentName];
    }
    else
    {
        self.focusName.text = focusModel.hospitalName;
        self.focusKeshiName.text=[NSString stringWithFormat:@"%@",focusModel.doctorName];
        self.doctorOfDeaprtmentName.text = [NSString stringWithFormat:@"   %@",focusModel.departmentName];
    }
 
}


- (IBAction)focusAction:(UIButton *)sender {
    [self.delegate focusViewChlick:self andClick:self.focusModel];
}
@end
