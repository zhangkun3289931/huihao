//
//  ZKChongZhiViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/18.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKChongZhiViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@interface ZKChongZhiViewController ()

@property (strong, nonatomic) IBOutlet UITextField *jinETextView;
- (IBAction)ZhiFuBtn:(UIButton *)sender;
- (IBAction)commit:(UIButton *)sender;
- (IBAction)JinEButton:(UIButton *)sender;

@property (strong, nonatomic)  NSString *appScheme;
@property (strong, nonatomic) NSString *orderString;

@end

@implementation ZKChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0. 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    self.appScheme = @"huihaoAliPay";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self.view endEditing:YES];
}

- (IBAction)JinEButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            self.jinETextView.text=@"10";
            break;
        case 1:
            self.jinETextView.text=@"20";
            break;
        case 2:
            self.jinETextView.text=@"50";
            break;
        case 3:
            self.jinETextView.text=@"100";
            break;
        default:
            break;
    }
    
}
- (IBAction)ZhiFuBtn:(UIButton *)sender {
    [self loadApliPay];
}

- (IBAction)commit:(UIButton *)sender {
    [self loadApliPay];
}
- (void)loadApliPay
{
    if ([self.jinETextView.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入充值的金额"];
        return;
    }
    
    if(self.jinETextView.text.integerValue>1000)
    {
        [MBProgressHUD showError:@"不能超过1000"];
         return;
    }
    
    ZKUserModdel *userModel=[ZKUserTool user];
    
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId,
                           @"fee":self.jinETextView.text
                           };
   
    NSLog(@"%@",params);
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/alipay/charge.do",baseUrl] params:params success:^(id json) {
        self.orderString=[[json objectForKey:@"body"]objectForKey:@"url"];
        NSLog(@"%@",json);
        [[AlipaySDK defaultService] payOrder:self.orderString fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];

}
@end
