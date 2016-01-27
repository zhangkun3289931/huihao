//
//  ZKCommonHeaderView.m
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKCommonHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ZKDetialViewController.h"
#import "ZKNavViewController.h"
@interface ZKCommonHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (strong, nonatomic) IBOutlet UILabel *keshiName;
@property (strong, nonatomic) IBOutlet UILabel *keshiQiCount;
@property (strong, nonatomic) IBOutlet UILabel *keshiScore;
@property (strong, nonatomic) IBOutlet UILabel *keshiNum;
@property (strong, nonatomic) IBOutlet UILabel *keshiQiFenSi;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *conetntLb;
- (IBAction)moreBtn:(UIButton *)sender;
- (IBAction)jinqiAction:(UIButton *)sender;
@end

@implementation ZKCommonHeaderView

+ (instancetype)commonHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZKCommonHeaderView" owner:nil options:nil]firstObject];
}
- (void)awakeFromNib {
    // Initialization code
    self.imageIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageIcon.layer.borderWidth = 1.0;

    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]];
}
- (IBAction)moreBtn:(UIButton *)sender {
    //NSLog(@"more");
    [self.delegate commonHeaderButtonClick:self];
}

- (IBAction)jinqiAction:(UIButton *)sender {
    [self.delegate commonHeaderJnqiButtonClick:self];
}
- (void)setKeshiModel:(ZKKeShiModel *)keshiModel
{
    _keshiModel=keshiModel;
}
- (void)setKeshiDetialModel:(ZKKeShiDetialModel *)keshiDetialModel
{
    _keshiDetialModel=keshiDetialModel;
    
    self.keshiNum.text=[NSString stringWithFormat:@"%@条",keshiDetialModel.totalUserAmount];

    self.keshiScore.text=[NSString stringWithFormat:@"%@分",keshiDetialModel.totalFeeling];
    
    self.keshiQiCount.text=[NSString stringWithFormat:@"%@面",keshiDetialModel.flagCount];
    self.keshiQiFenSi.text=[NSString stringWithFormat:@"%@人",keshiDetialModel.concernCount];
   
    [self.imageIcon sd_setImageWithURL:keshiDetialModel.imgUrl];
    
    self.keshiName.text=keshiDetialModel.departmentTypeName;
    
    self.titleLb.text=keshiDetialModel.hospitalName;
    
    
 
    NSString *desTemp = keshiDetialModel.hospitalBrief;
    if (keshiDetialModel.hospitalBrief.length > 60) {
        desTemp = [keshiDetialModel.hospitalBrief substringToIndex:60];
    }
    self.conetntLb.text=[NSString stringWithFormat:@"%@...更多",desTemp];

}


- (void)setCornCount:(NSInteger)cornCount
{
    _cornCount=cornCount;
     self.keshiQiFenSi.text=[NSString stringWithFormat:@"%zd人",cornCount];
}
@end
