//
//  ZKCommonToolBarView.m
//  huihao
//
//  Created by 张坤 on 16/1/25.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKCommonToolBarView.h"





@interface ZKCommonToolBarView()
- (IBAction)commonToolBarAction:(ZKCommentButton *)sender;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewF;
@property (strong, nonatomic) IBOutlet ZKCommentButton *attentionBtn;

@end

@implementation ZKCommonToolBarView

+ (instancetype)commonToolBarView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZKCommonToolBarView" owner:nil options:nil] firstObject];
}

- (IBAction)commonToolBarAction:(ZKCommentButton *)sender {
    [self.delegate commonToolBarView:self withClickItem:sender];
}

- (void)setToolBarTitles:(NSArray *)toolBarTitles
{
    _toolBarTitles = toolBarTitles;
    for (int i=0; i<self.stackViewF.subviews.count; i++) {
        ZKCommentButton *btn = self.stackViewF.subviews[i];
        [btn setTitle:toolBarTitles[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            NSString *title =  toolBarTitles[0];
            if ([title isEqualToString:@"送鲜花"]) {
                ZKCommentButton *btn = self.stackViewF.subviews.firstObject;
                [btn setImage:[UIImage imageNamed:@"send_flower"] forState:UIControlStateNormal];
            }
        }
    }
    
  
}


- (void)setIsAttention:(NSString *)isAttention
{
    _isAttention = [isAttention copy];
     NSLog(@"---%@",self.isAttention);
     self.attentionBtn.enabled = !self.isAttention.integerValue;
}
@end
