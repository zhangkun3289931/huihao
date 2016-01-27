//
//  ZKAddDoctorController.m
//  huihao
//
//  Created by Alex on 15/10/9.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKAddDoctorController.h"
#import "ZKDoctorCommonModel.h"
#import "ZKDoctorTableViewCell.h"
#import "ZKGetConmmentViewController.h"
#import "ZKNavViewController.h"
#import "ZKCommonHeaderView.h"
#import "ZKDetialViewController.h"
#import "ZKTongyuQiangViewController.h"
#import "MJRefresh.h"
#import "ZKDoctorCommonViewController.h"

@interface ZKAddDoctorController () <ZKDoctorTableViewCellDelegate,ZKCommonHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray *commentDataSource;
@property (nonatomic,strong) NSString *searchResult;
@property (nonatomic,copy) NSString *diseaseId;
@property (nonatomic,copy) NSString *areaID;
@property (nonatomic,copy) NSString *departmentTypeId;
@property (nonatomic,copy) NSString *order;
@property (nonatomic,assign) int pageNext;
@property (nonatomic,strong)  MJRefreshAutoNormalFooter *footer;
@property (strong, nonatomic)  ZKKeShiCommonModel *commonModel;
@property (nonatomic,strong) ZKCommonHeaderView *headerView;
@property (nonatomic,strong) NSString  *flagCount;
@property (nonatomic,strong) ZKKeShiDetialModel *keshiDetial;
@property (nonatomic, strong) NSString *hospitalBrief;
@property (nonatomic, strong) NSString *concernCount;
@end

@implementation ZKAddDoctorController
- (NSMutableArray *)commentDataSource
{
    if (!_commentDataSource) {
        _commentDataSource=[NSMutableArray array];
    }
    return _commentDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationController.title=self.keshiModel.departmentTypeName;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.pageNext=1;
    [self setupKeShiDetialData];
    [self setupUpLoad];
    [self setupKeshiList];
}
/**
 *  2. 上啦加载
 */
- (void)setupUpLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupKeshiList)];
    self.footer=footer;
    self.tableView.footer=footer;
}

/**
 *  加载科室详情数据
 */
- (void)setupKeShiDetialData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *departmentId=  self.keshiModel.departmentId;
    if (departmentId.length==0) {
        departmentId=self.doctorModel.departmentId;
    }
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"departmentId":departmentId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshi.do",baseUrl] params:params success:^(id json) {
        NSDictionary *data=[[[json objectForKey:@"body"]objectForKey:@"data"] firstObject];
        
        self.flagCount=[data objectForKey:@"flagCount"];
       // NSString *conStr=[data objectForKey:@"concern"];
        // self.concern=conStr.intValue;
        self.hospitalBrief=[data objectForKey:@"hospitalBrief"];
        self.concernCount=[data objectForKey:@"concernCount"];
        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshiDetail.do",baseUrl] params:params success:^(id json) {
            
            NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
            ZKCommonHeaderView *headerView=[ZKCommonHeaderView commonHeaderView];
            ZKKeShiDetialModel *keshiDetial=  [[ZKKeShiDetialModel mj_objectArrayWithKeyValuesArray:data] firstObject];
            keshiDetial.flagCount=self.flagCount;
            keshiDetial.hospitalBrief=self.hospitalBrief;
            keshiDetial.concernCount= self.concernCount;
            headerView.frame=CGRectMake(0, 0, self.view.width, 157
                                        );
            headerView.delegate=self;
            
            headerView.keshiDetialModel=keshiDetial;
            self.keshiDetial=keshiDetial;
            self.headerView=headerView;
            [self reloadTable];
            self.tableView.tableHeaderView=headerView;
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD hideHUD];
            
        }];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        
    }];
}
- (void) setupKeshiList
{
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"departmentId":(self.keshiModel.departmentId==nil)?self.doctorModel.departmentId:self.keshiModel.departmentId,
                           @"pageNumber":[NSString stringWithFormat:@"%d",self.pageNext],
                           @"hospitalName":(self.keshiModel.hospitalName==nil)?self.doctorModel.hospitalName:self.keshiModel.hospitalName,
                           };
    
    [MBProgressHUD showMessage:LoaderString(@"httpLoadText")];
    [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/doctor/getDoctorsList.do",baseUrl] params:params success:^(id json) {
        [self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSArray *data=[ZKDoctorModel objectArrayWithKeyValuesArray:[[json objectForKey:@"body"]objectForKey:@"data"]];
        NSString *pageN=[[json  objectForKey:@"body"]objectForKey:@"pageNext"];
        [self isDisplayPlusHold:data.count];
        if (self.pageNext>pageN.integerValue) {
            [self.footer setTitle:LoaderString(@"upNODataText") forState:MJRefreshStateIdle];
            return ;
        }
        [self.commentDataSource addObjectsFromArray:data];
        [self reloadTable];
        self.pageNext++;
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求数据失败，请检查网络"];
    }];

}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)commonHeaderButtonClick:(ZKCommonHeaderView *)common
{
    ZKDetialViewController *detial=[[ZKDetialViewController alloc]init];
    detial.title=self.keshiDetial.departmentTypeName;
    detial.hospitalBrief=self.hospitalBrief;
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:detial];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)commonHeaderJnqiButtonClick:(ZKCommonHeaderView *)common
{
    ZKTongyuQiangViewController *jinqiVC=[[ZKTongyuQiangViewController alloc]init];
    ZKNavViewController *nav = [[ZKNavViewController alloc]initWithRootViewController:jinqiVC];
    jinqiVC.title=@"锦旗墙";
    NSLog(@"%@",self.keshiModel);
    jinqiVC.keshiModel=self.keshiModel;
    jinqiVC.doctorModel = self.doctorModel;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKDoctorTableViewCell *cell=[ZKDoctorTableViewCell tagCellWithTableView:tableView];
    cell.delegate=self;
    ZKDoctorModel *doctorModel=self.commentDataSource[indexPath.row];
    cell.doctorModel=doctorModel;
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消tableViewCell选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ZKDoctorCommonViewController *doctor=[[ZKDoctorCommonViewController alloc]init];
    ZKDoctorModel *doctorModel= self.commentDataSource[indexPath.row];
    doctor.title=[NSString stringWithFormat:@"%@-%@",doctorModel.doctorName,doctorModel.position];
    doctor.doctorModel=doctorModel;
    [self.navigationController pushViewController:doctor animated:YES];
}
-(void)doctorTableViewCellWithClick:(ZKDoctorTableViewCell *)cell button:(UIButton *)button
{
    // NSLog(@"%@",cell.doctorModel.doctorName);
    ZKGetConmmentViewController *getVC=[[ZKGetConmmentViewController alloc]init];
    getVC.title=[NSString stringWithFormat:@"%@简介",cell.doctorModel.doctorName];
    getVC.doctorModel=cell.doctorModel;
    [self.navigationController pushViewController:getVC animated:YES];
}
- (void) isDisplayPlusHold:(NSInteger)num
{
    self.tableView.tableFooterView=[[UIView alloc]init];
    if (num==0) {
        CGFloat imageWH=100;
        UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 400)];
        // footView.backgroundColor=[UIColor redColor];
        UIImageView *imageView= [[UIImageView alloc]init];
        // imageView.x=self.view.x;
        CGFloat dx= (self.view.width-100)*0.5;
        imageView.frame=CGRectMake(dx, dx, imageWH, imageWH);
        [imageView setImage:[UIImage imageNamed:@"error_image"]];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [footView addSubview:imageView];
        
        UILabel *label=  [[UILabel alloc]init];
        label.frame=CGRectMake(0, CGRectGetMaxY(imageView.frame)+10,  self.view.width, 20);
        label.textAlignment=NSTextAlignmentCenter;
        label.text=@"暂无数据";
        [footView addSubview:label];
        self.tableView.tableFooterView=footView;
    }
}
@end
