//
//  ZKBingScrollerView.m
//  huihao
//
//  Created by 张坤 on 15/12/2.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKBingScrollerView.h"
#import "NSString+Extension.h"
#define tagFont [UIFont systemFontOfSize:12.0]


@interface ZKBingScrollerView()
@property (nonatomic,strong) NSMutableArray *labels;
@property (nonatomic,strong) UILabel *firstLabel;
@property (nonatomic,strong) UILabel *lastLabel;

@property (nonatomic,strong) NSArray  *ZKCustomRandomColor;
@end
@implementation ZKBingScrollerView
- (NSMutableArray *)labels
{
    if (!_labels) {
        _labels=[NSMutableArray arrayWithCapacity:2];
        for (int i=0; i<2; i++) {
            UILabel *firstLabel=[[UILabel alloc]init];
            firstLabel.font=tagFont;
            firstLabel.layer.cornerRadius=5;
            firstLabel.layer.masksToBounds=YES;
            firstLabel.textAlignment=NSTextAlignmentCenter;
            firstLabel.backgroundColor=[ZKCommonTools customColor];
            firstLabel.textColor=[UIColor whiteColor];
            [_labels addObject:firstLabel];
            [self addSubview:firstLabel];
        }
    }
    return _labels;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        
    }
    return self;
}
- (void)setTagList:(NSArray *)tagList
{
    _tagList=tagList;
    
    
    for (int i=0; i<self.labels.count; i++) {
        UILabel *label=self.labels[i];
        if (i<tagList.count) {
            label.hidden=NO;
            NSString *firstDisplayName =[tagList[i] objectForKey:@"diseaseName"];
            label.text=firstDisplayName;
        }else
        {
            label.hidden=YES;
        }
    }
    
    [self setNeedsLayout];
}
//- (void)setupLabel {
//
//}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
     CGFloat nextX =0.0;
    
    if (self.tagList.count>2) {
        return;
    }
    
    
    for (int i=0; i<self.tagList.count; i++) {
        UILabel *label=self.labels[i];
        NSString *firstDisplayName =[self.tagList[i] objectForKey:@"diseaseName"];
        CGSize firstLabelSize=[firstDisplayName sizeWithFont:tagFont];
        label.frame=CGRectMake(nextX, 0, firstLabelSize.width+10, self.height);
    
            nextX=CGRectGetMaxX(label.frame)+5;
        
        self.contentSize=CGSizeMake(CGRectGetMaxX(label.frame), 0);
    }
}
@end
