//
//  ZKSitchBingControllerTableViewController.m
//  huihao
//
//  Created by Alex on 15/9/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSitchBingController.h"
#import "ZKHTTPTool.h"
#import "ZKUserTool.h"
#import "ZKBingModel.h"
@interface ZKSitchBingController ()
@property (nonatomic,strong) NSArray *tempA;
@end

@implementation ZKSitchBingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 30.0;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(close)];
    
    NSString * departmentId = self.keshiModel.departmentId;
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    
    
    NSDictionary *params=@{
                           @"departmentId":departmentId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshi.do",baseUrl] params:params success:^(id json) {
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            NSDictionary *dcit= [[[[json objectForKey:@"body"] objectForKey:@"data"] firstObject] objectForKey:@"diseaseMap"];
            NSMutableArray *arrayTem=[NSMutableArray array];
            
            [dcit enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
                ZKBingModel *model=[[ZKBingModel alloc]init];
                model.diseaseName=obj;
                model.diseaseId=key;
                [arrayTem addObject:model];
            }];
            ZKBingModel *model=[[ZKBingModel alloc]init];
            model.diseaseName=@"其他";
            model.diseaseId=@"19999";
        
            [arrayTem addObject:model];
        
            self.tempA=arrayTem;
         
            [self reloadTable];
        }
    }  failure:^(NSError *error) {
         [MBProgressHUD showMessage:@"请检查你的网络" toView:self.view];
    }];
    
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  self.tempA.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.height=30;
        cell.textLabel.width=self.view.width;
        cell.textLabel.textColor=[UIColor colorWithWhite:0.151 alpha:1.000];
        cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
       
    }
    ZKBingModel *model=self.tempA[indexPath.row];
    cell.textLabel.text =model.diseaseName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate switchItem:self switchWithItem:self.tempA[indexPath.row]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL) isDisplayPlusHold:(NSInteger)num
{
    self.tableView.tableFooterView=[[UIView alloc]init];
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
        return YES;
    }else
    {
        return NO;
    }
}


@end
