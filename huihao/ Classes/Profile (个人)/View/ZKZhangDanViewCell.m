//
//  ZKZhangDanViewCell.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKZhangDanViewCell.h"
@interface ZKZhangDanViewCell()
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *des;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UIImageView *imageType;

@end
@implementation ZKZhangDanViewCell

+(instancetype)tagCellWithTableView:(UITableView *)tableView
{
    //可充用标识符
    static NSString *ID=@"zhangdanCell";
    ZKZhangDanViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKZhangDanViewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ZKZhangDanModel *)model
{
    _model=model;
    
    self.time.text=model.time;
    self.des.text=model.accountDes;
    if (model.accountDes.length==0) {
        self.des.text=model.realName;
    }
    
    if (model.payType == ZKBillStateRegion  || model.payType == ZKBillStateFlower ){
         self.des.text = @"";
        
        if (model.payType == ZKBillStateFlower ) {
             self.imageType.image = [UIImage imageNamed:@"flower_item"];
        }else if(model.payType == ZKBillStateRegion)
        {
             self.imageType.image = [UIImage imageNamed:@"flag_wall_red"];
        }
       
    }else{
        self.imageType.image = [UIImage imageNamed:@""];
    }
    
    
    self.price.text=[NSString stringWithFormat:@"%@元",model.fee];
}
@end
