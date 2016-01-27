//
//  TagCell.h
//  huihao
//
//  Created by 张坤 on 15/11/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *viewBg;

@property (strong, nonatomic) IBOutlet UILabel *text;

-(void)setTitleStr:(NSString *)title color:(NSString *)color;
@end
