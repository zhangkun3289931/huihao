//
//  ZKAddDepartmentViewController.m
//  huihao
//
//  Created by 张坤 on 16/1/21.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKAddDepartmentViewController.h"
#import "ZKTextView.h"
#import "ZKRedioButton.h"
@interface ZKAddDepartmentViewController ()
@property (strong, nonatomic) IBOutlet UITextField *departmentName;
@property (strong, nonatomic) IBOutlet UITextField *departmentHospital;
@property (strong, nonatomic) IBOutlet ZKTextView *departmentDeital;
- (IBAction)addDepartmentAction:(ZKRedioButton *)sender;

@end

@implementation ZKAddDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化UI
    [self setupUI];
}

- (void)setupUI
{
    self.departmentDeital.borderClolor= [UIColor whiteColor];
    self.departmentDeital.placeHoder = @"请输入医院简介（选填）";
}

- (IBAction)addDepartmentAction:(ZKRedioButton *)sender {
    //1.非空判断
    if (self.departmentName.text.length==0) {
        [MBProgressHUD showError:@"请输入科室名称"];
        return;
    }
    if (self.departmentHospital.text.length==0) {
        [MBProgressHUD showError:@"请输入科室所属医院名称"];
        return;
    }
    
    ZKUserModdel *userModel=[ZKUserTool user];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userModel != NULL) {
         params[@"sessionId"] = userModel.sessionId;
    }
    params[@"departmentName"] = self.departmentName.text;
    params[@"hospitalName"] = self.departmentHospital.text;
    params[@"departmentDesc"] = self.departmentDeital.text;

    NSLog(@"%@",params);
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/addDepartment.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            [MBProgressHUD showSuccess:@"添加科室成功，审核中..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            sender.enabled = NO;
        }
    } state:^(NSString *state) {
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求数据失败，请检查网络"];

    } andController:self];
}
@end
