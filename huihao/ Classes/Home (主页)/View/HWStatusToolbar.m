//
//  HWStatusToolbar.m
//  黑马微博2期
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWStatusToolbar.h"
#import "UIImageView+WebCache.h"
#import "ZKSettingButton.h"
@interface HWStatusToolbar()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的label */
@property (nonatomic, strong) NSMutableArray *btnLabels;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *repostBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;
@property (nonatomic,weak) UIButton *nextButton;
@end

const NSInteger buttonWH = 80;

@implementation HWStatusToolbar

- (NSMutableArray *)btns
{
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray *)btnLabels
{
    if (!_btnLabels) {
        _btnLabels=[NSMutableArray array];
    }
    return _btnLabels;
}
- (NSMutableArray *)dividers
{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setModels:(NSArray *)models
{
    _models=models;
    for (int i=0;i<models.count ; i++) {
        ZKZhengZhuangModel *model=models[i];
        ZKSettingButton *btn = [ZKSettingButton buttonWithType:UIButtonTypeCustom];
        UILabel *btnLabel = [[UILabel alloc] init];
        btnLabel.text=model.symptomName;
        btnLabel.textAlignment=NSTextAlignmentCenter;
        btnLabel.font = [UIFont systemFontOfSize:12.0f];
        
        btn.tag=i;
        
        [btn.imageView sd_setImageWithURL:[NSURL URLWithString:model.symptomImageOffUrl]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [btn setImage:image forState:UIControlStateNormal];
        }];
        
   
       [btn setBackgroundImage:[UIImage imageNamed:@"tongyong_botton_hui"] forState:UIControlStateSelected];
        [btnLabel setTextColor:[UIColor blackColor]];

       // btn.backgroundColor=[UIColor blueColor];
        [btn addTarget:self action:@selector(switchClick1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn addSubview:btnLabel];
        [self.btns addObject:btn];
        
        [self.btnLabels addObject:btnLabel];
        if (i==0) {
            [self switchClick1:btn];
        }
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
     self.frame = CGRectMake(0, 0, buttonWH, buttonWH * self.models.count);
    
    // 设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = buttonWH;
    CGFloat btnH = buttonWH;
    CGFloat margin = 2;
    CGFloat labelH = 20;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        UILabel *btnLabel=self.btnLabels[i];
        btn.y = i*(btnH+margin);
        btn.x = 0;
        btn.width = btnW;
        btn.height = btnH;
        
        btnLabel.x=0;
        btnLabel.y = btnW- labelH;
        btnLabel.height = labelH;
        btnLabel.width = btnW;
    }
}
- (void)switchClick1:(ZKSettingButton *)button
{
    self.nextButton.selected=NO;
    button.selected=YES;
    self.nextButton=button;

    //NSLog(@"sdf");
    [self.dalegate toolBar:self clickButton:button];
}

@end
