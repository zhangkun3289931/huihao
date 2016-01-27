//
//  ZKFocusTableViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//
#import "ZKFocusTableViewController.h"
#import "ZKUserTool.h"
#import "ZKHTTPTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKFocusViewCell.h"
#import "ZKConst.h"
#import "ZKFocusModel.h"
#import "ZKDepartmentCommonViewController.h"
#import "ZKDoctorCommonViewController.h"
#import "ZKFocusHeaderView.h"
#import "ZKGroupModel.h"
#import "huihao.pch"
@interface ZKFocusTableViewController () <ZKFocusViewCellDelegate,focusHeaderViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataSourceChuLi;
@property (nonatomic,strong) NSMutableDictionary *dataSourceDict;
@property (nonatomic,strong)  NSArray *keys;
@property (nonatomic,assign) BOOL isSelected;
@end

@implementation ZKFocusTableViewController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)dataSourceChuLi
{
    if (!_dataSourceChuLi) {
        _dataSourceChuLi=[NSMutableArray array];
    }
    return _dataSourceChuLi;
}
- (NSMutableDictionary *)dataSourceDict
{
    if (!_dataSourceDict) {
        _dataSourceDict=[NSMutableDictionary dictionary];
    }
    return _dataSourceDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化UI
    [self setupUI];
    // 2.加载数据
    [self loadData];
}

- (void)setupUI
{
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.view.backgroundColor=HuihaoBG;
    self.tableView.sectionHeaderHeight = 30 + 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)loadData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId
                           };
    [MBProgressHUD showMessage: LoaderString(@"httpLoadText")];
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getAttentionList.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        
        [self isDisplayPlusHold:data.count];
        
        [self ChuLiData:data];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
//处理data
- (void)ChuLiData:(NSArray *)data
{
    [self.dataSource addObjectsFromArray:[ZKFocusModel mj_objectArrayWithKeyValuesArray:data]];
    
    NSMutableArray *yishengArray=[NSMutableArray array];
    NSMutableArray *keshiArray=[NSMutableArray array];
    
    [self.dataSource enumerateObjectsUsingBlock:^(ZKFocusModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type ==1) {
            [yishengArray addObject:obj];
        }else
        {
            [keshiArray addObject:obj];
        }
    }];
    
    ZKGroupModel *keshiModel=[[ZKGroupModel alloc]init];
    keshiModel.opened=YES;
    keshiModel.name=@"已关注的科室";
    keshiModel.imgName=[UIImage imageNamed:@"attention_department"];
    keshiModel.friends=keshiArray;
    
    if (keshiArray.count>0) {
        [self.dataSourceChuLi addObject:keshiModel];
    }
    
    ZKGroupModel *yishengModel=[[ZKGroupModel alloc]init];
    yishengModel.name=@"已关注的医生";
    yishengModel.imgName=[UIImage imageNamed:@"attention_doctor"];
    
    yishengModel.opened=YES;
    yishengModel.friends=yishengArray;
    if (yishengArray.count>0) {
        [self.dataSourceChuLi addObject:yishengModel];
    }
    
    
    [self reloadTable];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZKGroupModel *groupModel=  self.dataSourceChuLi[section];
    NSArray *array=groupModel.friends;
    return (groupModel.isOpened ? array.count : 0);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceChuLi.count;
}
- (void)regionController:(ZKFocusHeaderView*) region buttonType:(BOOL) isSelect
{
    [self reloadTable];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZKGroupModel *groupModel=  self.dataSourceChuLi[section];
    return groupModel.name;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZKFocusHeaderView *headr=[[ZKFocusHeaderView alloc]init];
    headr.delegate=self;
    ZKGroupModel *groupModel=self.dataSourceChuLi[section];
    headr.groupModel=groupModel;
    return headr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKFocusViewCell *cell=[ZKFocusViewCell tagCellWithTableView:tableView];
    ZKGroupModel *groupModel=  self.dataSourceChuLi[indexPath.section];
    NSArray *array=groupModel.friends;
    cell.focusModel= array[indexPath.row];
    cell.delegate=self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKGroupModel *groupModel =  self.dataSourceChuLi[indexPath.section];
    NSArray *array=groupModel.friends;
    ZKFocusModel *focusModel = array[indexPath.row];
    
    if (focusModel.type==2) {
        ZKDepartmentCommonViewController *test1=[[ZKDepartmentCommonViewController alloc]init];
        ZKKeShiModel *keshi=[[ZKKeShiModel alloc]init];
        keshi.departmentTypeName=focusModel.departmentName;
        keshi.departmentId=focusModel.departmentId;
        test1.title=focusModel.departmentName;
        test1.keshiModel=keshi;
        [self.navigationController pushViewController:test1 animated:YES];
    }else
    {
        ZKDoctorCommonViewController *doctor=[[ZKDoctorCommonViewController alloc]init];
        ZKDoctorModel *doctorModel= [[ZKDoctorModel alloc]init];
        doctorModel.doctorId=focusModel.doctorId;
        doctorModel.doctorName=focusModel.doctorName;
        doctor.title=focusModel.doctorName;
        doctor.doctorModel=doctorModel;
        [self.navigationController pushViewController:doctor animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)focusViewChlick:(ZKFocusViewCell *)cell andClick:(ZKFocusModel *)focusModel
{
 
    NSString *name=focusModel.doctorName;
    if (name.length==0)name=focusModel.departmentName;
   
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"取消对-%@-的关注?",name]preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZKUserModdel *userModel=[ZKUserTool user];
        ZKGroupModel *groupModel;
        if (focusModel.type == 2) {
            groupModel = self.dataSourceChuLi[0];
        }else
        {
            groupModel=  self.dataSourceChuLi[1];
        }
       // ZKGroupModel *
        NSArray *array=groupModel.friends;
        //NSMutableArray *arrayTemp= self.dataSourceDict[key];
        [self fourcedisp:focusModel arrayTemp:(NSMutableArray *)array userModel:userModel];
    }];
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (void)fourcedisp:(ZKFocusModel *)focusModel arrayTemp:(NSMutableArray *)arrayTemp userModel:(ZKUserModdel *)userModel
{
    if (focusModel.type==1) {
        NSDictionary *params=@{
                               @"sessionId":userModel.sessionId,
                               @"doctorId":focusModel.doctorId,
                               @"doctorName":focusModel.doctorName
                               };
        NSLog(@"%@",params);
        //[MBProgressHUD showMessage:@"关注中..."];
        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/cancelAttentionToDoctor.do",baseUrl]params:params success:^(id json) {
            
            [arrayTemp removeObject:focusModel];
            
            NSLog(@"%@",arrayTemp);
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD hideHUD];
            
        }];
        
    }else
    {
        NSDictionary *params=@{
                               @"sessionId":userModel.sessionId,
                               @"departmentId":focusModel.departmentId,
                               @"departmentName":focusModel.departmentName
                               };
        NSLog(@"%@",params);
        //[MBProgressHUD showMessage:@"关注中..."];
        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/deleteKeshiGuanzhu.do",baseUrl]params:params success:^(id json) {
            [arrayTemp removeObject:focusModel];
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD hideHUD];
        }];
    }
    
       [self reloadTable];
}
- (void) isDisplayPlusHold:(NSInteger)num
{
    self.tableView.tableFooterView=[[UIView alloc]init];
    if (num==0) {
    self.tableView.tableFooterView = [self.view showErrorView];
    }
}
@end
