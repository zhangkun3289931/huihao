//
//  ZKSegmentControl.m
//  huihao
//
//  Created by 张坤 on 16/1/14.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKSegmentControl.h"

@implementation ZKSegmentControl


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initUI];
}

- (void) initUI{
    //设置背景色
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
    
    NSDictionary *dictNormal=@{
                               NSForegroundColorAttributeName:TabBottomTextSelectColor
                               };
    
    [self setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    
    NSDictionary *dictSelected=@{
                                 NSForegroundColorAttributeName:HuihaoRedBG
                                 };
    
    [self setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self setBackgroundImage:[UIImage imageNamed:@"comment_selectde"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
   CGContextRef context =  UIGraphicsGetCurrentContext();
    
    //2. 拼接路径
    UIBezierPath *bezierPath=[UIBezierPath bezierPath];
    //设置起点
    [bezierPath moveToPoint:CGPointMake(0 , self.height - 1)];
    [bezierPath addLineToPoint:CGPointMake(self.width, self.height - 1)];
    [HuihaoBG set];
    //添加到上下文
    //3. bezierPath.CGPath 直接把uikit的路径转换成cg的路径
    CGContextAddPath(context, bezierPath.CGPath);
    //4. 渲染上下文
    CGContextStrokePath(context);

}


@end
