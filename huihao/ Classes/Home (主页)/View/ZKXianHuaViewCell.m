//
//  ZKXianHuaViewCell.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKXianHuaViewCell.h"
@interface ZKXianHuaViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *xianHuanIcon;
@property (weak, nonatomic) IBOutlet UILabel *xianhuaCount;
@property (weak, nonatomic) IBOutlet UILabel *xianhuaDetial;
@property (weak, nonatomic) IBOutlet UILabel *xianhuaName;
@property (weak, nonatomic) IBOutlet UILabel *xianhuaTime;
@property (strong, nonatomic) IBOutlet UIView *flowerView;

@end
@implementation ZKXianHuaViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
{
    //可充用标识符
    static NSString *ID=@"xianhuaCell";
    
    ZKXianHuaViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKXianHuaViewCell" owner:nil options:nil] lastObject];
        cell.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code

    self.xianHuanIcon.layer.cornerRadius = self.xianHuanIcon.width*0.5;
    self.xianHuanIcon.layer.borderWidth = 1;
    self.xianHuanIcon.layer.borderColor = BorderColor.CGColor;
    self.xianHuanIcon.layer.masksToBounds=YES;
}
- (void)setXinhuaModel:(ZKXinhuaModel *)xinhuaModel
{
    _xinhuaModel=xinhuaModel;
    [self.xianHuanIcon sd_setImageWithURL:[NSURL URLWithString:xinhuaModel.headIcon] placeholderImage:[UIImage imageNamed:@"image_bg"]];
    self.xianhuaName.text=xinhuaModel.realName;
    
    
    if(xinhuaModel.realName.length == 0){
        self.xianhuaName.text = xinhuaModel.userName;
    }

    self.xianhuaTime.text=xinhuaModel.time;
    NSString *flowNums = [NSString stringWithFormat:@"%@朵",xinhuaModel.flowerNum];;
    if (flowNums.integerValue > 5) {
        flowNums = [NSString stringWithFormat:@"... %@朵",xinhuaModel.flowerNum];
    }
    
    self.xianhuaCount.text=flowNums;
    self.xianhuaDetial.text=xinhuaModel.flowerDes;//
    
    [self createFlowerView:xinhuaModel.flowerNum.integerValue];
}

- (void)createFlowerView :(NSUInteger)count{
//    for (int i=0; i<self.flowerView.subviews.count; i++) {
//        UIImageView *imageView = self.flowerView.subviews[i];
//        if (count > imageView.tag)
//        {
//            imageView.hidden = YES;
//        }else
//        {
//            imageView.hidden = NO;
//        }
//    }
    
    for (UIImageView *imageView in self.flowerView.subviews.firstObject.subviews) {
        NSLog(@"w3wwfw3");
        if (imageView.tag < count) {
            imageView.image = [UIImage imageNamed:@"flower_item"];
        }else
        {
            imageView.image = [UIImage imageNamed:@""];

        }
    }
}
@end
