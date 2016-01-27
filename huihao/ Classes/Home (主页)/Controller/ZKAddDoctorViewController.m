//
//  ZKAddDoctorViewController.m
//  huihao
//
//  Created by 张坤 on 15/12/15.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKAddDoctorViewController.h"
#import "ZKTextView.h"

@interface ZKAddDoctorViewController ()
@property (strong, nonatomic) IBOutlet UITextField *doctorName;
@property (strong, nonatomic) IBOutlet UITextField *doctorKeshi;
@property (strong, nonatomic) IBOutlet UITextField *doctorHospital;
@property (strong, nonatomic) IBOutlet UITextField *doctorZhiCheng;


@property (strong, nonatomic) IBOutlet ZKTextView *doctoerDetial;

- (IBAction)addDoctorAction:(UIButton *)sender;

@end

@implementation ZKAddDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 初始化UI
    [self setupUI];
}

- (void)setupUI
{
    self.doctoerDetial.borderClolor= [UIColor whiteColor];
    self.doctoerDetial.placeHoder = @"请输入医生简介（选填）";
}

- (void)isNotNil
{
    //    if (self.doctorZhiCheng.text.length==0) {
//        [MBProgressHUD showError:@"请输入医生职称"];
//        return;
//    }
//    if (self.doctorName.text.length==0) {
//        [MBProgressHUD showError:@"请输入其它备注"];
//        return;
//    }
}
- (IBAction)addDoctorAction:(UIButton *)sender {
    
    //1.非空判断
    if (self.doctorName.text.length == 0) {
        [MBProgressHUD showError:@"请输入医生姓名"];
        return;
    }
    if (self.doctorKeshi.text.length == 0) {
        [MBProgressHUD showError:@"请输入科室名称"];
        return;
    }
    if (self.doctorHospital.text.length == 0) {
        [MBProgressHUD showError:@"请输入医院名称"];
        return;
    }

    
    ZKUserModdel *userModel=[ZKUserTool user];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userModel != NULL) {
        params[@"sessionId"] = userModel.sessionId;
    }
    params[@"doctorName"] = self.doctorName.text;
    params[@"hospitalName"] = self.doctorHospital.text;
    params[@"departmentName"] = self.doctorKeshi.text;
    params[@"doctorDesc"] = self.doctoerDetial.text;
    
    [MBProgressHUD showMessage:LoaderString(@"httpLoadText")];
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/addDoctor.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            [MBProgressHUD showSuccess:@"添加医生成功，审核中..."];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } state:^(NSString *state) {
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求数据失败，请检查网络"];
    } andController:self];

}
@end
