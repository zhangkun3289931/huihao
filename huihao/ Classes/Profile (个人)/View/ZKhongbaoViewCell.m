//
//  ZKhongbaoViewCell.m
//  huihao
//
//  Created by Alex on 15/9/30.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKhongbaoViewCell.h"
@interface ZKhongbaoViewCell()
@property (weak, nonatomic) IBOutlet UILabel *hongbaoMoney;
@property (weak, nonatomic) IBOutlet UILabel *hongbaoTime;

@end
@implementation ZKhongbaoViewCell
+(instancetype)tagCellWithTableView:(UITableView *)tableView
{
    //可重用标识符
    static NSString *ID=@"hongbaoCell";
    ZKhongbaoViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];

    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ZKhongbaoViewCell" owner:nil options:nil] lastObject];
        //cell.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setHongbaoModel:(ZKHongBaoModel *)hongbaoModel
{
    _hongbaoModel=hongbaoModel;
    self.hongbaoMoney.text=hongbaoModel.fee;
    self.hongbaoTime.text=hongbaoModel.time;
}

@end
