//
//  ZKLoginViewController.m
//  huihao
//
//  Created by Alex on 15/9/15.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKRegisterViewController.h"
#import "ZKHTTPTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKUserTool.h"
#import "APService.h"
#import "ZKforGetPwdControllerViewController.h"
@interface ZKLoginViewController () <UIAlertViewDelegate,ZKRegisterViewControllerDelegate>
- (IBAction)close:(UIButton *)sender;
/** 注册*/
- (IBAction)registerClick:(UIButton *)sender;
/** 忘记密码*/
- (IBAction)foegetPwd:(UIButton *)sender;
/** 登录*/
- (IBAction)Login:(UIButton *)sender;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UITextField *userName;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *userPwd;

@end

@implementation ZKLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
  //  NSLog(@"------%@",[self uuid]);
     [self.userName addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    
    [self.userName setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.userPwd setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    

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

- (void)valueChange:(UITextField *)tf
{
    if (tf.text.length>11) {
        [MBProgressHUD showError:@"手机号只能输入11位数字"];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerClick:(UIButton *)sender {
    ZKRegisterViewController *registerVC=[[ZKRegisterViewController alloc]init];
    registerVC.delegate=self;
    [self presentViewController:registerVC animated:YES completion:nil];
    
}

- (IBAction)foegetPwd:(UIButton *)sender {

    
    ZKforGetPwdControllerViewController *registerVC=[[ZKforGetPwdControllerViewController alloc]init];
    //[registerVC.optionView removeFromSuperview];
    registerVC.title=@"找回密码";
    [self presentViewController:registerVC animated:YES completion:nil];
    
    
}
- (IBAction)Login:(UIButton *)sender {
   // ZKUserModdel *userModel=[ZKUserTool user];
    NSString *userName=self.userName.text;
    NSString *userPwd=self.userPwd.text;
    if (userName.length!=11 || userPwd.length<6 || userPwd.length>12)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或者密码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
         return;
    }
    NSDictionary *params=@{
                           @"username":userName,
                           @"password":userPwd,
                           @"deviceId":[self uuid]
                           };
    [MBProgressHUD showMessage:@"正在登录中请稍等..."];

    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/userLogin.do",baseUrl] params:params success:^(id json) {
        NSLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            [MBProgressHUD showSuccess:@"登录成功"];
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
        [MBProgressHUD showError:@"请检查用户名跟密码！"];
    }];
}
- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}

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
- (void)registerViewController:(ZKRegisterViewController *)vc
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self dismissViewControllerAnimated:YES completion:nil];
    });
}
@end
