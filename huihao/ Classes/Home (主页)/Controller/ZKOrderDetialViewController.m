//
//  ZKOrderDetialViewController.m
//  huihao
//
//  Created by Alex on 15/9/25.
//  Copyright © 2015年 张坤. All rights reserved.
//
#import "ZKOrderDetialViewController.h"
#import "ZKRedioButton.h"
#import "ZKXianhuaViewController.h"
#import "ZKTongyuQiangViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ZKOrderDetialViewController ()
- (IBAction)sendAction:(ZKRedioButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *orderDetial;

@property (weak, nonatomic) IBOutlet UILabel *order_name;
@property (weak, nonatomic) IBOutlet UIButton *order_count;
@property (weak, nonatomic) IBOutlet UIImageView *orderData;
@property (weak, nonatomic) IBOutlet UILabel *order_jinqi_Data;
@property (weak, nonatomic) IBOutlet UILabel *order_jinqi_Right_Data;
@property (weak, nonatomic) IBOutlet UILabel *order_Price;
@property (weak, nonatomic) IBOutlet UITextField *order_send_name;
@property (strong, nonatomic) IBOutlet UILabel *orderSendPeple;
@property (strong, nonatomic) IBOutlet ZKRedioButton *sendButton;

@property (strong, nonatomic)  NSString *appScheme;
@property (strong, nonatomic)  NSString *orderString;

@end

@implementation ZKOrderDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0. 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    self.appScheme = @"huihaoAliPay";
    // 1. 初始化nav
    [self setupNav];
    // 2. 初始化订单信息
    [self initOrderData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupNav
{
     self.navigationItem.rightBarButtonItem=nil;
    
    //[self.order_send_name setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)initOrderData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *defalutName = userModel.nickName;
    if (defalutName.length == 0) {
        defalutName = userModel.username;
    }
    
    
    self.orderSendPeple.text = defalutName;

    if (self.xianhuaModel!=NULL){
        self.order_name.text=@"太阳花";
        self.order_count .hidden = NO;
        [self.order_count setTitle:[NSString stringWithFormat:@"%@朵",self.xianhuaModel.flowerNum] forState:UIControlStateNormal];
        self.order_count.backgroundColor =HuihaoRedBG;
          [self.order_count setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        
        [self.orderData setImage:[UIImage imageNamed:@"xianhua"]];
        self.order_jinqi_Data.text=@"";
         self.order_jinqi_Right_Data.text=@"";
        NSInteger count=self.xianhuaModel.flowerNum.integerValue;
        self.orderDetial.text = self.xianhuaModel.flowerDes ;
        self.order_Price.text=[NSString stringWithFormat:@"￥%zd",count ];
    }else
    {
        self.order_name.text=@"您选择的锦旗";
        self.order_count .hidden = YES;
        self.order_count.backgroundColor = [UIColor whiteColor];
        [self.order_count setTitleColor:HuihaoRedBG forState:UIControlStateNormal];
        
        [self.orderData sd_setImageWithURL:[NSURL URLWithString:self.detialModel.flagImgUrl]];
        self.order_jinqi_Data.text=self.detialModel.des;
        self.order_Price.text=[NSString stringWithFormat:@"￥%@",self.detialModel.flagPrice];
        
        NSInteger conetntLength=self.detialModel.des.length*0.5;
        self.order_jinqi_Data.text=[self.detialModel.des substringToIndex:conetntLength];

        self.order_jinqi_Right_Data.text=[self.detialModel.des substringFromIndex:conetntLength];
    }
}

- (IBAction)sendAction:(ZKRedioButton *)sender {
    
    if (self.xianhuaModel!=NULL) {
        [self showPayAlertWithType:ZKPayTypeXianhua];
    } else {
        [self showPayAlertWithType:ZKPayTypeJinQi];
    }
}
/**
 *  展示alert
 */
- (void)showPayAlertWithType:(ZKPayType)type
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择支付方式？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *aliPayAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alipayClick:type];
    }];
    UIAlertAction *balancePayAction = [UIAlertAction actionWithTitle:@"余额" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self blanceClick:type];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:aliPayAction];
    [alert addAction:balancePayAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)alipayClick:(ZKPayType)type
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    [params setValue:userModel.userId forKey:@"userId"];
    if (self.order_send_name.text.length != 0) {
        [params setValue:self.order_send_name.text forKey:@"realName"];
    }
    
    if (type == ZKPayTypeXianhua) {
        [params setValue:@"送鲜花" forKey:@"title"];
        [params setValue:self.doctorModel.doctorId forKey:@"doctorId"];
        [params setValue:self.xianhuaModel.flowerNum forKey:@"flowerNum"];
        [params setValue:self.xianhuaModel.flowerDes forKey:@"des"];
        
        [self getOrderString:params withUrl:[NSString stringWithFormat:@"%@inter/alipay/payFlower.do",baseUrl]];
        
    } else {
        [params setValue:@"送锦旗" forKey:@"title"];

        [params setValue:self.keshiModel.departmentId forKey:@"departmentId"];
        [params setValue:self.detialModel.flagId forKey:@"flagId"];
        [params setValue:self.detialModel.des forKey:@"flagContent"];
        [params setValue:self.detialModel.isDiy forKey:@"isDIY"];
        [self getOrderString:params withUrl:[NSString stringWithFormat:@"%@inter/alipay/giveFlag.do",baseUrl]];
    }
}
/**
 *  获取支付字符传
 *
 *  @param params  参数
 *  @param url    url
 */
- (void) getOrderString:(NSDictionary *)params withUrl:(NSString *)url
{
    [MBProgressHUD showMessage:@"支付中..."];
    [ZKHTTPTool POST:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        self.orderString=[[json objectForKey:@"body"]objectForKey:@"url"];
        [[AlipaySDK defaultService] payOrder:self.orderString fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"支付结果 = %@",resultDic);
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
- (void)blanceClick:(ZKPayType)type
{
    [MBProgressHUD showMessage:@"支付中..."];
    ZKUserModdel *userModel=[ZKUserTool user];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    [params setValue:userModel.userId forKey:@"userId"];
    if (self.order_send_name.text.length != 0) {
        [params setValue:self.order_send_name.text forKey:@"realName"];
    }
    NSString *url;
    if (type == ZKPayTypeXianhua) {
        [params setValue:self.doctorModel.doctorId forKey:@"doctorId"];
        [params setValue:self.xianhuaModel.flowerNum forKey:@"flowerNum"];
        [params setValue:@"送鲜花" forKey:@"title"];
        [params setValue:@"送鲜花" forKey:@"content"];
        [params setValue:self.xianhuaModel.flowerDes forKey:@"des"];
        url= [NSString stringWithFormat:@"%@inter/alipay/payFlowerByBalance.do",baseUrl];
    } else {
        NSString *departmentId = self.keshiModel.departmentId;
        if (departmentId.length == 0) {
            departmentId = self.doctorModel.departmentId;
        }
        [params setValue:departmentId forKey:@"departmentId"];
        [params setValue:self.detialModel.flagId forKey:@"flagId"];
        [params setValue:self.detialModel.des forKey:@"flagContent"];
        [params setValue:self.detialModel.isDiy forKey:@"isDIY"];
        url= [NSString stringWithFormat:@"%@inter/alipay/giveFlagByBalance.do",baseUrl];
    }
    [self payInfo:params withUrl:url];

}
- (void) payInfo:(NSDictionary *)params withUrl:(NSString *)url
{
    if (self.xianhuaModel!=NULL) {
        [ZKHTTPTool POST:url params:params success:^(id json) {
            NSString *stateStr= [json objectForKey:@"state"];
            [MBProgressHUD hideHUD];
            
            ZKXianhuaViewController *vc=[[ZKXianhuaViewController alloc]init];
            vc.title=@"鲜花簇";
            vc.doctorModel=self.doctorModel;
            vc.keshiModel = self.keshiModel;
            
            ZKNavViewController *nvc = [[ZKNavViewController alloc]initWithRootViewController:vc];
            if (0==stateStr.integerValue) {
                [MBProgressHUD showSuccess:@"支付成功"];

                [self.navigationController presentViewController:nvc animated:YES completion:^{
                    NSArray *controllers=self.navigationController.viewControllers;
                    [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-3] animated:NO];
                }];

                
            }else
            {
                [MBProgressHUD showError: [json objectForKey:@"des"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
        }];
    }else//锦旗
    {
        [ZKHTTPTool POST:url params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            if (![ZKCommonTools JudgeState:json controller:nil]) return ;
            ZKTongyuQiangViewController *vc=[[ZKTongyuQiangViewController alloc]init];
            vc.title=@"锦旗墙";
            vc.keshiModel=self.keshiModel;
            vc.doctorModel = self.doctorModel;
            ZKNavViewController *nvc = [[ZKNavViewController alloc]initWithRootViewController:vc];
            [MBProgressHUD showSuccess:@"支付成功"];
            [self.navigationController presentViewController:nvc animated:YES completion:^{
                NSArray *controllers=self.navigationController.viewControllers;
         
                if (self.detialModel.isDiy.integerValue==1) {
                        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-4] animated:NO];
                }else
                {
                        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-3] animated:NO];
                }
            }];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求失败"];
        }];
        
    }
}
@end
