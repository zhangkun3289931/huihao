//
//  ZKSearchTableViewCell.h
//  huihao
//
//  Created by 张坤 on 16/1/12.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKSearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *line;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong, nonatomic) IBOutlet UIImageView *orderImage;
@property (strong,nonatomic) NSString *orderByStr;
@end
