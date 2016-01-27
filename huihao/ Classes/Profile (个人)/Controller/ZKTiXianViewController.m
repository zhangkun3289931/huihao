//  ZKTiXianViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/18.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKTiXianViewController.h"
#import "ZKZhangDanViewController.h"

@interface ZKTiXianViewController ()
@property (weak, nonatomic) IBOutlet UITextField *payName;
@property (weak, nonatomic) IBOutlet UITextField *payAccount;
@property (weak, nonatomic) IBOutlet UITextField *payMoney;

@end

@implementation ZKTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化nav
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commentClick)];
    
   NSString *ploceHodeStr= [NSString stringWithFormat:@"最多可以提取%@元",self.yueMoney];
    if (self.yueMoney.length==0) {
        ploceHodeStr= [NSString stringWithFormat:@"最多可以提取0元"];
    }
    self.payMoney.placeholder=ploceHodeStr;
    [self.payMoney addTarget:self action:@selector(moneyAction:) forControlEvents:UIControlEventAllEditingEvents];
    [self.payName addTarget:self action:@selector(nameAction:) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
};
- (void)commentClick
{
    //NSLog(@"commentClick");
    NSInteger payMon= self.payMoney.text.integerValue;
    if (payMon<50) {
        [MBProgressHUD showError:@"不能低于50元"];
        return;
    }
   CGFloat dealt= (payMon-self.yueMoney.integerValue);
    if(dealt>0)
    {
        [MBProgressHUD showError:@"余额不足"];
        return;
    }
ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId,
                           @"fee":self.payMoney.text,
                           @"alipay":self.payAccount.text,
                           @"realName":self.payName.text
                           };
    //  [MBProgressHUD showMessage:@"加载中"];
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/applyCash.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"提交成功,审核中..."];
        [MBProgressHUD hideHUD];
    
        
        ZKZhangDanViewController *zhangDanVC = [[ZKZhangDanViewController alloc]init];
        zhangDanVC.title = @"账单明细";
        [self.navigationController pushViewController:zhangDanVC animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];
    
}
- (void)nameAction:(UITextField *)sender
{
    if (sender.text.length>8) {
        sender.text=[sender.text substringToIndex:7];
    }
}
- (void)moneyAction:(UITextField *)sender
{
    if (self.yueMoney.integerValue<(sender.text.integerValue)) {
        sender.text=[NSString stringWithFormat:@"%zd",self.yueMoney.integerValue];
    }
}
@end
