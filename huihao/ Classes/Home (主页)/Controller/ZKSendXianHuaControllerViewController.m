//
//  ZKSendXianHuaControllerViewController.m
//  huihao
//
//  Created by Alex on 15/9/25.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSendXianHuaControllerViewController.h"
#import "ZKTextView.h"
#import "ZKOrderDetialViewController.h"
#import "ZKXianhuaViewController.h"
#import "ZKRedioButton.h"
#import "ZKXinhuaModel.h"
@interface ZKSendXianHuaControllerViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *first;
- (IBAction)sendClick:(ZKRedioButton *)sender;
- (IBAction)xianhuacuBtn:(UIButton *)sender;
- (IBAction)swotchHuaAction:(ZKRedioButton *)sender;

@property (weak, nonatomic) IBOutlet ZKTextView *content;
@property (strong, nonatomic) IBOutlet UILabel *xainhuaCount;
@property (strong, nonatomic) IBOutlet UITextField *QitaTF;

@property (strong, nonatomic) IBOutlet ZKRedioButton *optionButton1;
@property (strong, nonatomic) IBOutlet ZKRedioButton *optionButton2;
@property (strong, nonatomic) IBOutlet ZKRedioButton *optionButton3;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) NSString *huaCount;
@property (nonatomic,strong) NSString *huaContent;

@end
@implementation ZKSendXianHuaControllerViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    
}
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  初始化一些数据
 */
- (void)setupUI{
    self.button=self.first;
    
    self.content.font=[UIFont systemFontOfSize:13];
    self.content.placeHoder=@"说几句感谢医生的话，限三十个字以内";
    self.content.alwaysBounceVertical=YES;
    
    self.xainhuaCount.text=[NSString stringWithFormat:@"%@朵",self.doctorModel.smartValue];
    
    self.QitaTF.delegate=self;
    self.QitaTF.layer.cornerRadius = self.QitaTF.height * 0.5 ;
    self.QitaTF.layer.masksToBounds = YES;
}

#pragma mark -action
- (IBAction)swotchHuaAction:(ZKRedioButton *)sender {
    self.button.selected=NO;
    sender.selected=YES;
    [self.view endEditing:YES];
    self.QitaTF.background = [UIImage imageNamed:@"tongyong_botton_hui"];
    self.QitaTF.text =@"";
    
    self.huaCount=[sender.titleLabel.text substringToIndex:1];

    self.button=sender;
}
- (IBAction)sendClick:(ZKRedioButton *)sender {
      [self.view endEditing:YES];

    
    if (self.huaCount.length == 0) {
        [MBProgressHUD showError:@"请选择太阳花" toView:self.view
         ];
        return;
    }
    if (self.content.text.length >= 30 ){
        [MBProgressHUD showError:@"感谢医生的话,限三十个字以内" toView:self.view
         ];
        return;
    }
    
    ZKOrderDetialViewController *order=[[ZKOrderDetialViewController alloc]init];
    ZKXinhuaModel *xianHuaModel=[[ZKXinhuaModel alloc]init];
    xianHuaModel.flowerNum=self.huaCount;
    xianHuaModel.flowerDes=self.content.text;
    order.title=@"送鲜花";
    order.doctorModel=self.doctorModel;
    order.xianhuaModel=xianHuaModel;
    [self.navigationController pushViewController:order animated:YES];
}
- (IBAction)xianhuacuBtn:(UIButton *)sender {
    ZKXianhuaViewController *xianhuaVC=[[ZKXianhuaViewController alloc]init];
    ZKNavViewController *nav = [[ZKNavViewController alloc]initWithRootViewController:xianhuaVC];
    xianhuaVC.title=@"鲜花簇";
    xianhuaVC.doctorModel=self.doctorModel;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark textFiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.integerValue>=100) {
        [MBProgressHUD showError:@"最多只能送99朵鲜花"];
        self.huaCount=textField.text=@"99";
        return;
    }
    if (textField.text.integerValue<=0) {
        [MBProgressHUD showError:@"最少只能送1朵鲜花"];
        self.huaCount=textField.text=@"1";
        return;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.QitaTF.textColor = [UIColor whiteColor];
    self.QitaTF.background = [UIImage imageNamed:@""];
    self.QitaTF.backgroundColor = HuihaoRedBG;
    
    self.optionButton1.selected=NO;
    self.optionButton2.selected=NO;
    self.optionButton3.selected=NO;
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.huaCount=textField.text;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
