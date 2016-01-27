//
//  UITableView+ZKTableView.m
//  huihao
//
//  Created by 张坤 on 16/1/14.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "UITableView+ZKTableView.h"

@implementation UITableView (ZKTableView)

- (void)showErrorHint
{
    [self showErrorHintWithNum:0];
}

- (BOOL) showErrorHintWithNum:(NSInteger)num
{
    self.tableFooterView=[[UIView alloc]init];

    if (num==0) {
        CGFloat imageWH = 100.0f;
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 400)];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        CGFloat dx = (self.width - imageWH) * 0.5;
        
        imageView.frame = CGRectMake(dx, dx, imageWH, imageWH);
        [imageView setImage:[UIImage imageNamed:@"error_image"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [footView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+10,  self.width, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = LoaderString(@"upNODataText");
        label.font=[UIFont systemFontOfSize:13.0f];
        label.textColor=[UIColor blackColor];
        [footView addSubview:label];
        self.tableFooterView = footView;
        return YES;
    }else
    {
        return NO;
    }
}

@end
