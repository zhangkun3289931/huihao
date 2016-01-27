
//
//  ZKMyAccountMoneyController.m
//  huihao
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//
#import "ZKMyAccountMoneyController.h"
#import "UIBarButtonItem+ZKExtaion.h"
#import "ZKZhangDanViewController.h"
#import "ZKChongZhiViewController.h"
#import "ZKTiXianViewController.h"
#import "ZKHongBaoViewController.h"
@interface ZKMyAccountMoneyController ()
@property (weak, nonatomic) IBOutlet UILabel *YuELabel;

- (IBAction)hongBao:(UIButton *)sender;
- (IBAction)zhongzhi:(UIButton *)sender;
- (IBAction)zhangdan:(UIButton *)sender;
- (IBAction)quanAction:(UIButton *)sender;

@property (nonatomic,strong) NSString *yueMoney;
@end

@implementation ZKMyAccountMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化nav
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(moneyClick)];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 2.获取余额
    [self loadYuE];
    
}
- (void)loadYuE
{
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getBalance.do",baseUrl] params:params success:^(id json) {
        NSDictionary *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        self.yueMoney=[data objectForKeyedSubscript:@"balance"];
        self.YuELabel.text=[NSString stringWithFormat:@"%@元",self.yueMoney];
        if (self.yueMoney.length==0) {
            self.YuELabel.text=@"0元";
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];

}
- (void)moneyClick
{
    ZKTiXianViewController *tixian=[[ZKTiXianViewController alloc]init];
    tixian.title=@"提现";
    tixian.yueMoney=self.yueMoney;
    [self.navigationController pushViewController:tixian animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hongBao:(UIButton *)sender {
    ZKHongBaoViewController *hongbao=[[ZKHongBaoViewController alloc]init];
    hongbao.title=@"我的红包";
    [self.navigationController pushViewController:hongbao animated:YES];
}
- (IBAction)zhongzhi:(UIButton *)sender {
    ZKChongZhiViewController *zhongzhi=[[ZKChongZhiViewController alloc]init];
    zhongzhi.title=@"充值";
    [self.navigationController pushViewController:zhongzhi animated:YES];
}

- (IBAction)zhangdan:(UIButton *)sender {
    ZKZhangDanViewController *zhangdan=[[ZKZhangDanViewController alloc]init];
    zhangdan.title=@"账单明细";
    [self.navigationController pushViewController:zhangdan animated:YES];
}

- (IBAction)quanAction:(UIButton *)sender {
//    //ZKQuanViewController *quanVC = [[ZKQuanViewController alloc]init];
//    quanVC.title=@"购物券";
//    [self.navigationController pushViewController:quanVC animated:YES];
}
@end
