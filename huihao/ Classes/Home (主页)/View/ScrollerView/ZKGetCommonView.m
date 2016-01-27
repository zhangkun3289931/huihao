//
//  ZKGetCommonView.m
//  huihao
//
//  Created by 张坤 on 15/10/12.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKGetCommonView.h"
#import "ZKGetCommonButton.h"
#import "UIView+Extension.h"
@interface ZKGetCommonView()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UIButton  *nextButton;
@end
@implementation ZKGetCommonView

+ (instancetype)toolbar
{
    return [[self alloc]init];
}

- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
-(void)setModels:(NSArray *)models
{
    _models=models;
    for (int i=0;i<2 ; i++) {
        ZKIMageModel *imageModel=models[i];

        ZKGetCommonButton *btn = [ZKGetCommonButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:imageModel.imageName forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageModel.imageNormalName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageModel.imageSelectedName] forState:UIControlStateSelected];
        
        btn.tag=i;
        [btn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btns addObject:btn];
        
        
        if(i==0)
        {
            btn.selected=YES;
            self.nextButton=btn;
        }
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat margin=2;
    CGFloat btnW = (self.width-margin*btnCount)/btnCount;
    CGFloat btnH =self.height;
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i*(btnW+margin);
        btn.height = btnH;
    }
}
- (void)switchClick:(ZKGetCommonButton *)button
{
    self.nextButton.selected=NO;
    button.selected=YES;
    self.nextButton=button;
    
    [self.delegate foreButtonView:self clickButton:button type:self.type];
}



@end
