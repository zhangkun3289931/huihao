//
//  ZKRegisterViewController.m
//  huihao
//
//  Created by Alex on 15/9/15.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKRegisterViewController.h"
#import "ZKHTTPTool.h"
#import "APService.h"
#import "JKCountDownButton.h"
@interface ZKRegisterViewController ()
- (IBAction)close:(UIButton *)sender;

- (IBAction)registerClick:(UIButton *)sender;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userName;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
/** 验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
/**  再次密码*/
@property (weak, nonatomic) IBOutlet UITextField *user2Pwd;
/**  邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *invitationCode;
/**  用户协议*/
- (IBAction)userAgreetment:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet JKCountDownButton *yanZhengMaBT;
@property (assign, nonatomic)  BOOL isXunzhongXieyi;
/**  发送验证码*/
- (IBAction)sendVerification:(JKCountDownButton *)sender;

@end

@implementation ZKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
        [self.userName setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
        [self.userPwd setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
        [self.verificationCode setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
        [self.user2Pwd setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
        [self.invitationCode setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    self.optionView.hidden=YES;
    self.isXunzhongXieyi=YES;
    [self.userName addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
        [self.verificationCode addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
}
- (void)valueChange:(UITextField *)tf
{
    if (tf.text.length>11 && tf.tag==0) {
        [MBProgressHUD showError:@"手机号只能输入11位数字"];
    }
    if (tf.text.length>6 && tf.tag==1) {
        [MBProgressHUD showError:@"验证码最多只能输入6位数字"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    // NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    NSString * result=(NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerClick:(UIButton *)sender {
    NSString *userName=self.userName.text;
    NSString *userPwd=self.userPwd.text;
    NSString *user2Pwd=self.user2Pwd.text;
    NSString *verificationCode= self.verificationCode.text;
    NSString *invitationCode=self.invitationCode.text;
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
    if (!self.isXunzhongXieyi) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有勾选协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDictionary *params=@{
                           @"username":userName,
                           @"password":userPwd,
                           @"passwordConfirm":user2Pwd,
                           @"code":verificationCode,
                           @"inviteCode":invitationCode
                           };
    [MBProgressHUD showMessage:@"注册中，请稍等..."];
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/register.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
       if([ZKCommonTools JudgeState:json controller:nil])
       {
           [MBProgressHUD showSuccess:@"注册成功"];
           [self.delegate registerViewController:self];
           NSLog(@"%@",json);
           [self dismissViewControllerAnimated:YES completion:nil];
           ZKUserModdel *userModel=  [ZKUserModdel mj_objectWithKeyValues:[json objectForKey:@"body"]];
           [ZKUserTool saveAccount:userModel];
           //打包唯一标识
           [APService setAlias:[self uuid]
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        object:self];
           
           [self dismissViewControllerAnimated:YES completion:nil];
       }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"注册失败"];
    }];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    //    if ([_callBackTextView.text isEqualToString:@"服务器返回结果"]) {
    //        _callBackTextView.text = callbackString;
    //    } else {
    //        _callBackTextView.text = [NSString
    //                                  stringWithFormat:@"%@\n%@", callbackString, _callBackTextView.text];
    //    }
    NSLog(@"TagsAlias回调:%@", callbackString);
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (IBAction)sendVerification:(JKCountDownButton *)sender {
    NSString *userName=self.userName.text;
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


- (IBAction)userAgreetment:(UIButton *)sender {
    sender.selected=!sender.isSelected;
    self.isXunzhongXieyi=sender.isSelected;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
