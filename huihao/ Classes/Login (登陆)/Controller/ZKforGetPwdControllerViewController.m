//
//  ZKforGetPwdControllerViewController.m
//  huihao
//
//  Created by 张坤 on 15/10/12.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKforGetPwdControllerViewController.h"
#import "ZKLoginViewController.h"
#import "huihao.pch"
#import "JKCountDownButton.h"
@interface ZKforGetPwdControllerViewController ()
@property (strong, nonatomic) IBOutlet UITextField *GetPwdPhone;
@property (strong, nonatomic) IBOutlet UITextField *GetYanZhenMa;
@property (strong, nonatomic) IBOutlet UITextField *GetPwdP;
@property (strong, nonatomic) IBOutlet UITextField *Get2PwdP;
- (IBAction)closeAction:(UIButton *)sender;

- (IBAction)sendYanZhengMa:(JKCountDownButton *)sender;
- (IBAction)getPwdAction:(UIButton *)sender;
@end

@implementation ZKforGetPwdControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.GetPwdPhone setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.Get2PwdP setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.GetYanZhenMa setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.GetPwdP setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    // Do any additional setup after loading the view from its nib.
    [self.GetPwdPhone addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    [self.GetYanZhenMa addTarget:self action:@selector(valueChange1:) forControlEvents:UIControlEventAllEditingEvents];
}
- (void)valueChange:(UITextField *)tf
{
    
    if (tf.text.length>11) {
        [MBProgressHUD showError:@"手机号只能输入11位数字"];
    }
}
- (void)valueChange1:(UITextField *)tf
{
    if (tf.text.length>6) {
        [MBProgressHUD showError:@"验证码只能输入6位数字"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sendYanZhengMa:(JKCountDownButton *)sender {
    NSString *userName=self.GetPwdPhone.text;
    if (userName.length!=11)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查你您的手机号！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *params=@{
                           @"telNum":userName,
                           };
    [MBProgressHUD showMessage:@"发送验证码..."];
    
    [ZKHTTPTool POST: [NSString stringWithFormat:@"%@inter/user/sendCodeForReg.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"发送成功,请检查短信"];
        
        sender.enabled = NO;
        //button type要 设置成custom 否则会闪动
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
            
        }];

        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发送失败，请检查网络"];
    }];

}

- (IBAction)getPwdAction:(UIButton *)sender {
    NSString *userName=self.GetPwdPhone.text;
    NSString *userPwd=self.GetPwdP.text;
    NSString *user2Pwd=self.Get2PwdP.text;
    NSString *verificationCode= self.GetYanZhenMa.text;
   // NSString *invitationCode=self.invitationCode.text;
    if (userName.length!=11 | userPwd.length<6 || userPwd.length>12)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或者密码格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (verificationCode.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请发送验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![user2Pwd isEqualToString:userPwd]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ZKUserModdel *model= [ZKUserTool user];
    NSDictionary *params=@{
                        //   @"sessionId":model.sessionId,
                           @"username":userName,
                           @"newPassword":userPwd,
                           @"newPasswordConfirm":user2Pwd,
                           @"code":verificationCode
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/modify.do",baseUrl] params:params success:^(id json) {
        NSLog(@"%@",json);
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            ZKLoginViewController *loginVC=[[ZKLoginViewController alloc]init];
            [self.navigationController presentViewController:loginVC animated:YES completion:nil];
            [MBProgressHUD showSuccess:@"修改成功,请登录"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"修改失败"];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
