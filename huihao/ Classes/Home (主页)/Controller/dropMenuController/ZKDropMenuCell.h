//
//  ZKDropMenuCell.h
//  huihao
//
//  Created by 张坤 on 15/10/14.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKDropMenuCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIImageView *orderImageType;
@property (strong, nonatomic) IBOutlet UILabel *orderTextType;
@property (strong, nonatomic) IBOutlet UILabel *orderName;

@property (strong, nonatomic) IBOutlet UILabel *menuItemName;


@property (nonatomic,strong) NSString *title;
@end
