//
//  ZKTongyuQiangViewController.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKTongyuQiangViewController.h"
#import "ZKJinQiViewCell.h"
#import "ZKJinQiModel.h"
#import "ZKKeShiCommonModel.h"
#import "MJRefresh.h"
@interface ZKTongyuQiangViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int pageNext;
@property (nonatomic,assign) int numCount;
@property (nonatomic,strong)  MJRefreshAutoNormalFooter *footer;

@property (strong, nonatomic) IBOutlet UIImageView *rongyuIcon;
@property (strong, nonatomic) IBOutlet UILabel *rongyuContent;
@property (strong, nonatomic) IBOutlet UILabel *rongyuCount;

@end

@implementation ZKTongyuQiangViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNext = 1;
    self.title=@"锦旗墙";
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [self loadJinqiDetial];
    [self loadJinQItem];
    [self setupDownLoad];
    
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
    MJRefreshAutoNormalFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadJinQItem)];

    self.tableView.mj_footer=footer;
}


- (void)loadJinQItem
{
   // [MBProgressHUD showMessage:LoaderString(@"httpLoadText")];
    NSString *departmentId = self.keshiModel.departmentId;
    if (departmentId==NULL) {
        departmentId = self.doctorModel.departmentId;
    }
    NSDictionary *params=@{
                           @"departmentId":departmentId,
                           @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/listZengsongjinqi.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        [self isDisplayPlusHold:data.count];
        [self.dataSource addObjectsFromArray:[ZKJinQiModel mj_objectArrayWithKeyValuesArray:data]];
        
       self.numCount =[[[json objectForKey:@"body"]objectForKey:@"rowCount"] intValue];

        [self reloadTable];
        self.pageNext++;
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
/**
 *  加载科室详情数据
 */
- (void)loadJinqiDetial
{
    NSString *departmentId = self.keshiModel.departmentId;
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    if (departmentId.length == 0) {
        [MBProgressHUD showError:@"参数丢失"];
        return;
    }
    
    
    NSDictionary *params=@{
                           @"departmentId":departmentId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshi.do",baseUrl] params:params success:^(id json) {
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        
        ZKKeShiCommonModel *commonModel=  [[ZKKeShiCommonModel mj_objectArrayWithKeyValuesArray:data] firstObject];
        // NSLog(@"%@",data);
         self.rongyuCount.text=[NSString stringWithFormat:@"%zd面",commonModel.flagCount];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numCount == self.dataSource.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer resetNoMoreData];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKJinQiViewCell *cell = [ZKJinQiViewCell cellWithTableView:tableView];
    cell.jinQiModel=self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
