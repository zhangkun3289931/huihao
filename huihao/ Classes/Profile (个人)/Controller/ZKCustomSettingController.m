//
//  ZKCustomSettingController.m
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKCustomSettingController.h"
#import "ZKRegisterViewController.h"
#import "ZKUserTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKforGetPwdControllerViewController.h"
#import "ZKHTTPTool.h"
#import "huihao.pch"
@interface ZKCustomSettingController ()
- (IBAction)updatePwd:(UIButton *)sender;
- (IBAction)lorgetBtn:(UIButton *)sender;
@end

@implementation ZKCustomSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)updatePwd:(UIButton *)sender {
    ZKforGetPwdControllerViewController *registerVC=[[ZKforGetPwdControllerViewController alloc]init];
    //[registerVC.optionView removeFromSuperview];
    registerVC.title=@"修改密码";
    [self.navigationController presentViewController:registerVC animated:YES completion:nil];
}

- (IBAction)lorgetBtn:(UIButton *)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要退出登录?"]preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self lorgetHttpData];
            }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)lorgetHttpData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId
                           };
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/exit.do",baseUrl] params:params success:^(id json) {
        //NSDictionary *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            BOOL result=  [ZKUserTool deleteAccount];
            if (result) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [MBProgressHUD showError:@"退出登录失败"];
            }
            
        };
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];

}
@end
