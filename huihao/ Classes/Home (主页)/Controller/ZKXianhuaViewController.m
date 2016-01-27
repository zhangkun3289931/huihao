//
//  ZKXianhuaViewController.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKXianhuaViewController.h"
#import "ZKHTTPTool.h"
#import "ZKXinhuaModel.h"
#import "ZKXianHuaViewCell.h"
#import "MJRefresh.h"
@interface ZKXianhuaViewController ()
@property (strong, nonatomic) IBOutlet UILabel *xianhuaCount;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int pageNext;
@property (nonatomic,strong)  MJRefreshAutoNormalFooter *footer;
@end

@implementation ZKXianhuaViewController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNext=1;
    [self loadFlowNumber];
    
    [self loadFlowItem];
    
    [self setupDownLoad];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    

}
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  5. 上啦加载
 */
- (void)setupDownLoad
{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFlowItem)];
    //[self.tableView.footer beginRefreshing];
    self.footer=footer;
    self.tableView.footer=footer;
}
- (void)loadFlowItem
{
    NSDictionary *params=@{
                           @"doctorId":self.doctorModel.doctorId,
                            @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getFlowerList.do",baseUrl] params:params success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
       
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        [self.dataSource addObjectsFromArray:[ZKXinhuaModel mj_objectArrayWithKeyValuesArray:data]];
        [self isDisplayPlusHold:data.count];
         NSString *pageN=[[json objectForKey:@"body"]objectForKey:@"pageCount"];
        if (self.pageNext>pageN.integerValue) {
            [self.footer setTitle:LoaderString(@"upNODataText") forState:MJRefreshStateIdle];
            return ;
        }
        [self reloadTable];
        self.pageNext ++;
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [self.tableView.mj_footer endRefreshing];

        [MBProgressHUD hideHUD];
        
    }];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)loadFlowNumber
{
        NSDictionary *params=@{
                               @"doctorId":self.doctorModel.doctorId
                               };
        
        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getDoctorById.do",baseUrl] params:params success:^(id json) {
            NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
           // self.des=[[json objectForKey:@"body"]objectForKey:@"des"];
            
            ZKDoctorModel *doctorModel=[ZKDoctorModel mj_objectWithKeyValues:[data firstObject]];
            
          self.xianhuaCount.text=[NSString stringWithFormat:@"魅力值:%@", doctorModel.smartValue];
            [MBProgressHUD hideHUD];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.description);
            [MBProgressHUD hideHUD];
            
        }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKXianHuaViewCell *cell = [ZKXianHuaViewCell cellWithTableView:tableView];
    cell.xinhuaModel=self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}
- (BOOL) isDisplayPlusHold:(NSInteger)num
{
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
        return YES;
    }else
    {
        return NO;
    }
}

@end
