//
//  ZKZhangDanViewController.m
//  huihao
//
//  Created by Alex on 15/9/18.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKZhangDanViewController.h"
#import "ZKHTTPTool.h"
#import "ZKUserTool.h"
#import "ZKZhangDanModel.h"
#import "ZKZhangDanViewCell.h"
#import "ZKFocusHeaderView.h"
#import "ZKGroupModel.h"
#import "ZKFocusHeaderView.h"




@interface ZKZhangDanViewController ()<focusHeaderViewDelegate>
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataSourceChuLi;
//@property (nonatomic,strong) NSMutableDictionary *dataSourceDict;
@end

@implementation ZKZhangDanViewController
- (NSMutableArray *)dataSourceChuLi
{
    if (!_dataSourceChuLi) {
        _dataSourceChuLi=[NSMutableArray array];
    }
    return _dataSourceChuLi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化账单信息
    [self setupHttpData];
    
    self.tableView.tableFooterView= [[UIView alloc]init];
    self.tableView.backgroundColor= HuihaoBG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self setupNav];
}
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:0 target:self action:@selector(close)];
}
- (void)close
{
    
    NSArray *controllers=self.navigationController.viewControllers;
    // @"ZKGetConmmentViewController"
    
    
    
    UIViewController *secVC = controllers[1];
    
    
    [self.navigationController popToViewController:secVC animated:YES];
    
}
- (void)setupHttpData
{
    ZKUserModdel * model=  [ZKUserTool user];
    if (!model) {
        NSLog(@"没有登录");
        return;
    }
    NSDictionary *params=@{
                           @"sessionId":model.sessionId,
                           @"userId":model.userId
                           };
    [MBProgressHUD showMessage: LoaderString(@"httpLoadText")];
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getAccountList.do",baseUrl] params:params success:^(id json) {
         [MBProgressHUD hideHUD];
       NSArray *data=[ZKZhangDanModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"] objectForKey:@"data"]];
        [self isDisplayPlusHold:data.count];
        NSLog(@"%@",json);
        [self chuLiData: data];
        [self reloadTable];
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
- (void)chuLiData:(NSArray *)data
{

    
    NSMutableArray *xiaoFeiArray=[NSMutableArray array];
    NSMutableArray *chongZhiArray=[NSMutableArray array];
    NSMutableArray *tiXianArray=[NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(ZKZhangDanModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        switch (obj.payType) {
            case ZKBillStateFlower:
            case ZKBillStateRegion:
                [xiaoFeiArray addObject:obj];
                break;
            case ZKBillStatePay:
                [chongZhiArray addObject:obj];
                break;
            case ZKBillStateKiting:
                [tiXianArray addObject:obj];
                break;
                
            default:
                break;
        }
    }];
    
    ZKGroupModel *xiaoFeiModel=[[ZKGroupModel alloc]init];
    xiaoFeiModel.friends=xiaoFeiArray;
    xiaoFeiModel.imgName=[UIImage imageNamed:@"account_checkinfo1"];
    xiaoFeiModel.name=@"消费明细";
    xiaoFeiModel.opened=YES;
    ZKGroupModel *chongZhiModel=[[ZKGroupModel alloc]init];
    chongZhiModel.friends=chongZhiArray;
    chongZhiModel.imgName=[UIImage imageNamed:@"account_checkinfo2"];
    
    chongZhiModel.name=@"充值明细";
    chongZhiModel.opened=YES;
    ZKGroupModel *tiXianModel=[[ZKGroupModel alloc]init];
    tiXianModel.friends=tiXianArray;
    tiXianModel.imgName=[UIImage imageNamed:@"account_checkinfo3"];
    tiXianModel.name=@"提现明细";
    tiXianModel.opened=YES;
    if (xiaoFeiArray.count>0) {
        [self.dataSourceChuLi addObject:xiaoFeiModel];
    }
    if (chongZhiArray.count>0) {
        [self.dataSourceChuLi addObject:chongZhiModel];
    }
    
    if (tiXianArray.count>0) {
        [self.dataSourceChuLi addObject:tiXianModel];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)regionController:(ZKFocusHeaderView*) region buttonType:(BOOL) isSelect
{
    //self.isSelected=isSelect;
    [self reloadTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZKGroupModel *groupModel=  self.dataSourceChuLi[section];
    NSArray *array=groupModel.friends;
    return (groupModel.isOpened ? array.count : 0);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceChuLi.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKZhangDanViewCell *cell=[ZKZhangDanViewCell tagCellWithTableView:tableView];
    ZKGroupModel *groupModel=self.dataSourceChuLi[indexPath.section];
    cell.model=groupModel.friends[indexPath.row];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return  self.dataSourceChuLi[section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZKFocusHeaderView *headr=[[ZKFocusHeaderView alloc]init];
    headr.delegate=self;
    headr.headerType=1;
    ZKGroupModel *groupModel=self.dataSourceChuLi[section];
    headr.groupModel=groupModel;
    return headr;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}
- (void) isDisplayPlusHold:(NSInteger)num
{
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
    }
}

@end
