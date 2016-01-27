//
//  ZKForeButtonView.m
//  huihao
//
//  Created by Alex on 15/9/23.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKForeButtonView.h"
#import "ZKSwitchTypeButton.h"
@interface ZKForeButtonView()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) ZKSwitchTypeButton  *nextButton;
@end

@implementation ZKForeButtonView
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
        
        }
        return self;
}

-(void)setModels:(NSArray *)models
{
    _models=models;
    for (int i=0;i<models.count ; i++) {
        NSString *title=models[i];
        ZKSwitchTypeButton *btn = [ZKSwitchTypeButton initWithButtonImage:@"tongyong_botton_hui" selectImage:@"tongyong_botton_fen"];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setTitleColor:HuihaoBingTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setRoundWithcornerRadius:(self.height - 10) * 0.5];
        
        [btn setTitle:title forState:UIControlStateNormal];
    
        btn.tag=i;
        
      
        [btn addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self.btns addObject:btn];
    }

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat margin = 1;
    CGFloat btnW = (self.width-margin*btnCount)/btnCount;
    CGFloat btnH =self.height - 10;
    
    for (int i = 0; i<btnCount; i++) {
        ZKSwitchTypeButton *btn = self.btns[i];
        btn.y = 5;
        btn.width = btnW;
        btn.x = i*(btnW+margin);
        btn.height = btnH;
    }
}
- (void)switchClick:(ZKSwitchTypeButton *)button
{
    self.nextButton.selected=NO;
    
    button.selected=YES;
    
    self.nextButton=button;
    
    [self.delegate foreButtonView:self clickButton:button type:self.type];
}
@end
