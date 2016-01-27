//
//  ZKTextView.m
//  微博
//
//  Created by 张坤 on 15/9/8.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKTextView.h"
@interface ZKTextView()
@property (nonatomic,strong) UILabel *label;
@end
@implementation ZKTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //通知
        [self initUI];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self initUI];
}
- (void)initUI
{
    //一个通知
    NSNotificationCenter *notificationCenter =[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    self.font=[UIFont systemFontOfSize:12.0];
    self.textColor=[UIColor blackColor];
    self.placeClolor = HuihaoTextColor;
    self.borderClolor = HuihaoRedBG;
    
    self.layer.borderColor = self.borderClolor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;

}
- (void)setBorderClolor:(UIColor *)borderClolor
{
    _borderClolor=borderClolor;
    
    self.layer.borderColor = self.borderClolor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
}

- (void)textDidChange
{
    //重绘
    [self setNeedsDisplay];
    if (self.text.length>120) {
        //[MBProgressHUD showError:@"最多只能输入120字"];
        self.label.textColor=HuihaoRedBG;
        self.textColor=HuihaoRedBG;
    }else
    {
         self.label.textColor=BorderColor;
         self.textColor=[UIColor blackColor];
    }
  //self.label.text=[NSString stringWithFormat:@"%ld/120",self.text.length];
}

- (void)drawRect:(CGRect)rect
{
    if(self.hasText)return;
    NSDictionary *dict=@{
                         NSFontAttributeName:self.font,
                         NSForegroundColorAttributeName:self.placeClolor
                         };
    //[self.placeHoder drawAtPoint:CGPointMake(6, 8) withAttributes:dict];
    [self.placeHoder drawInRect:CGRectMake(6, 8, rect.size.width-12, rect.size.height-16)   withAttributes:dict];
    
}
- (void)dealloc
{
    NSNotificationCenter *notificationCenter  =[NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}
- (void)setPlaceHoder:(NSString *)placeHoder
{
    _placeHoder=[placeHoder copy];
    [self setNeedsDisplay];
}
- (void)setPlaceClolor:(UIColor *)placeClolor
{
    _placeClolor=placeClolor;
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
@end
