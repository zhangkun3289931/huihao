//
//  UITableView+ZKExtension.m
//  huihao
//
//  Created by 张坤 on 15/10/12.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "UITableView+ZKExtension.h"
#import "UIView+Extension.h"
#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@implementation UITableView (ZKExtension)

+ (UIView *) isDisplayPlusHold:(NSInteger)num
{
    CGFloat width=  [UIScreen mainScreen].bounds.size.width;
    if (num==0) {
        CGFloat imageWH=100;
        UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 400)];
        // footView.backgroundColor=[UIColor redColor];
        UIImageView *imageView= [[UIImageView alloc]init];
        // imageView.x=self.view.x;
        CGFloat dx= (width-100)*0.5;
        imageView.frame=CGRectMake(dx, dx, imageWH, imageWH);
        [imageView setImage:[UIImage imageNamed:@"error_image"]];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [footView addSubview:imageView];
        
        UILabel *label=  [[UILabel alloc]init];
        label.frame=CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, width, 20);
        label.textAlignment=NSTextAlignmentCenter;
        label.text=@"暂无数据";
        [footView addSubview:label];
        return footView;
        
    }else
    {
        return [[UIView alloc]init];
    }
}

@end
