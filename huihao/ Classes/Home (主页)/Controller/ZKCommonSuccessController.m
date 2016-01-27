//
//  ZKCommonSuccessController.m
//  huihao
//
//  Created by Alex on 15/10/9.
//  Copyright © 2015年 张坤. All rights reserved.
//
#import "ZKCommonSuccessController.h"
#import "ZKRedioButton.h"
#import "ZKAddDoctorController.h"
#import "ZKHongBaoViewController.h"
#import "ZKSendXianHuaControllerViewController.h"
#import "ZKpennantsViewController.h"
#import "ZKGetConmmentViewController.h"


@interface ZKCommonSuccessController ()
@property (nonatomic,assign) CGFloat hongBaoNum;
@property (strong, nonatomic) IBOutlet ZKRedioButton *continueCommenu;
@property (strong, nonatomic) IBOutlet UILabel *commentLB;
@property (strong, nonatomic) IBOutlet ZKRedioButton *sendFlowOrFlag;

- (IBAction)SendFlowOrFlagAction:(ZKRedioButton *)sender;
- (IBAction)SuccesslingAdd:(ZKRedioButton *)sender;
@end
@implementation ZKCommonSuccessController
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化nav
    [self setupNav];
    //2.加载红包信息
    [self loadHongbao];
    
}
/**
 *  加载红包信息
 */
- (void)loadHongbao
{
    ZKUserModdel *userModel=[ZKUserTool user];
    
    if (!self.isKeshi) {
        [self.continueCommenu setTitle:@"继续评价科室" forState:UIControlStateNormal];
         [self.sendFlowOrFlag setTitle:@"给该医生送鲜花" forState:UIControlStateNormal];
        
        //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
        NSDictionary *params=@{
                               @"sessionId":userModel.sessionId,
                               @"doctorId": self.doctorModel.doctorId,
                               @"level" :[NSString stringWithFormat:@"%d",self.hongbaoTy]
                               };
        NSLog(@"%@",params);
        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/sendHongbaoKeshiPjzy.do",baseUrl] params:params success:^(id json) {
            [MBProgressHUD hideHUD];
            NSLog(@"%@",json);
            if([ZKCommonTools JudgeState:json controller:nil])
            {
                NSString *num=[[[json objectForKey:@"body"] objectForKey:@"data"] substringFromIndex:2];
                self.hongBaoNum=num.doubleValue;
                if(self.hongBaoNum>0)
                {
                    [self showAlert];
                }
            }
            } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD hideHUD];
        }];
    }else
    {
        [self.continueCommenu setTitle:@"继续评价医生" forState:UIControlStateNormal];
        [self.sendFlowOrFlag setTitle:@"给该科室送锦旗" forState:UIControlStateNormal];
        //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
        NSString *departmentId = self.keshiModel.departmentId;
        if (departmentId.length ==0) {
            departmentId = self.doctorModel.departmentId;
        }
        
        NSDictionary *params=@{
                               @"sessionId":userModel.sessionId,
                               @"departmentId":departmentId,
                               @"level" :[NSString stringWithFormat:@"%d",self.hongbaoTy]
                               };
         NSLog(@"%@",params);
        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/sendHongbaoKeshiPjmz.do",baseUrl] params:params success:^(id json) {
             [MBProgressHUD hideHUD];
            NSLog(@"%@",json);
            if([ZKCommonTools JudgeState:json controller:nil])
            {
                NSString *num=[[[json objectForKey:@"body"] objectForKey:@"data"] substringFromIndex:2];
                self.hongBaoNum=num.doubleValue ;
                if(self.hongBaoNum>0)
                {
                    [self showAlert];
                }
            }

        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD hideHUD];
        }];
        
    }
}
/**
 *  出书啊nav
 */
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:0 target:self action:@selector(close)];
}
- (void)close
{
    //popToViewController-就是跳转到指定的视图控制器xxx，这个xxx一定要在这个栈里面，即一定是在我们当前这个视图控制器的下面的，所以跳转也就是把自己和在xxx上面的所有视图控制器都pop出去，然后相当于直接跳转到xxx
    
    //此处重点是这个xxx怎么获取，按照一般理解是用xxx再初始化一个视图控制器对象yyy，然后把这个对象yyy作为popToViewController参数
    
    //但事实是，yyy是新初始化的，不在栈中，当然和在栈中的xxx初始化的那个对象也不是同一个对象，所以会报错（因为在栈中找不到啊）
    
    //所以，self.navigationController.viewControllers出场，viewControllers是个数组，储存的时导航控制器栈中所有的视图控制器，最先push进去的时0，以此类推，最上面的肯定是数组的最后一个
    
    //所以，那个xxx之前初始化的对象，可以用[self.navigationController.viewControllers objectAtIndex:0]表示，此处0就是根视图控制器
    
    //所以，只要拿到navigationController，貌似能做很多事情
    
   NSArray *controllers=self.navigationController.viewControllers;
   // @"ZKGetConmmentViewController"
    

    
   UIViewController *secVC = controllers[1];
  
    if ([NSStringFromClass([secVC class]) isEqualToString:@"ZKGetConmmentViewController"]) {
          [self.navigationController popToViewController:controllers.firstObject animated:YES];
    }else
    {
          [self.navigationController popToViewController:secVC animated:YES];
    }
}
- (void)showAlert
{
   NSString *str= [NSString stringWithFormat:@"获得%0.1f元红包",self.hongBaoNum];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZKHongBaoViewController *hongbao=[[ZKHongBaoViewController alloc]init];
        hongbao.title=@"我的红包";
        [self.navigationController pushViewController:hongbao animated:YES];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)SuccessLingAction:(ZKRedioButton *)sender {
  
    [self showAlert];
}

- (IBAction)SendFlowOrFlagAction:(UIButton *)sender {
    
    if (!self.isKeshi) {
        ZKSendXianHuaControllerViewController *xianHuanVC = [[ZKSendXianHuaControllerViewController alloc]init];
        xianHuanVC.title = @"鲜花簇";
        xianHuanVC.doctorModel =self.doctorModel;

        [self.navigationController pushViewController:xianHuanVC animated:YES];
    }else
    {
        ZKpennantsViewController *pennantVC = [[ZKpennantsViewController alloc]init];
        pennantVC.keshiModel = self.keshiModel;
        pennantVC.doctorModel = self.doctorModel;
        
        pennantVC.title = @"锦旗墙";
        [self.navigationController pushViewController:pennantVC animated:YES];
    }
}

- (IBAction)SuccesslingAdd:(ZKRedioButton *)sender {
    if (!self.isKeshi) {
        ZKGetConmmentViewController *conmmentVC = [[ZKGetConmmentViewController alloc]init];
      
       // self.keshiModel.departmentId = self.doctorModel.departmentId;
        NSLog(@"%@",self.doctorModel);
        conmmentVC.isKeshi = 1;
        conmmentVC.keshiModel=self.keshiModel;
        conmmentVC.doctorModel=self.doctorModel;
        conmmentVC.title = [NSString stringWithFormat:@"评价%@",self.doctorModel.departmentName];
        [self.navigationController pushViewController:conmmentVC animated:YES];
        
    }else
    {
        ZKAddDoctorController *dc=[[ZKAddDoctorController alloc]init];
    
        dc.doctorModel=self.doctorModel;
        dc.keshiModel =self.keshiModel;
        NSString *departmentId=  self.keshiModel.departmentTypeName;
        if (departmentId.length==0) {
            departmentId=self.doctorModel.departmentName;
        }
        dc.title=departmentId;
        [self.navigationController pushViewController:dc animated:YES];
    }

   
}
@end
