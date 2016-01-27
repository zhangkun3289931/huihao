//
//  ZKHongBaoViewController.m
//  huihao
//
//  Created by Alex on 15/9/30.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKHongBaoViewController.h"
#import "ZKhongbaoViewCell.h"
#import "ZKHongBaoModel.h"
#import "ZKGetHongBaoViewController.h"
#import "MJRefresh.h"
@interface ZKHongBaoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *hongbaoLabel;
@property (weak, nonatomic) IBOutlet UIButton *hongbaoGet;
- (IBAction)hongbaoGetAction:(UIButton *)sender;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int pageNext;
@property (nonatomic,strong)  MJRefreshAutoNormalFooter *footer;
@end

@implementation ZKHongBaoViewController
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
    [self loadYuE];
    
    [self loadYuEItem];
    
    [self setupDownLoad];
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=45;
    
}


/**
 *  5. 上啦加载
 */
- (void)setupDownLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadYuEItem)];
    self.footer=footer;
    self.tableView.mj_footer=footer;
}

- (void)loadYuE
{
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId
                           };

    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getTotalRedPaper.do",baseUrl] params:params success:^(id json) {
        NSDictionary *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        //NSLog(@"%@",json);
        NSString *hongbaoMoney=[data objectForKeyedSubscript:@"totalRedPaper"];
        self.hongbaoLabel.text=[NSString stringWithFormat:@"%@元",hongbaoMoney];
        if (hongbaoMoney.length==0) {
            self.hongbaoLabel.text=@"0元";
        }
      
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}
- (void)loadYuEItem
{
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId,
                           @"userId":userModel.userId,
                           @"type":@"500",
                           @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };
  [MBProgressHUD showMessage: LoaderString(@"httpLoadText")];
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getRedPapersList.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.tableView.footer endRefreshing];

        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        //self.yueMoney=[data objectForKeyedSubscript:@"balance"];
         NSString *pageN=[[json objectForKey:@"body"]objectForKey:@"pageCount"];
       // [self isDisplayPlusHold:data.count];

        if (self.pageNext>pageN.integerValue) {
            [self.footer setTitle:LoaderString(@"upNODataText") forState:MJRefreshStateIdle];
            return ;
        }
        NSLog(@"%@",data);
        [self.dataSource addObjectsFromArray:[ZKHongBaoModel mj_objectArrayWithKeyValuesArray:data]];
        if (self.dataSource.count==0) {
            [MBProgressHUD showError:@"暂时没有红包"];
        }
        [self reloadTable];
        self.pageNext++;
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        [self.tableView.footer endRefreshing];
    }];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKhongbaoViewCell *cell=[ZKhongbaoViewCell tagCellWithTableView:tableView];
    cell.hongbaoModel=self.dataSource[indexPath.row];
    return cell;
}

- (IBAction)hongbaoGetAction:(UIButton *)sender {
    ZKGetHongBaoViewController *hongbaoVC=[[ZKGetHongBaoViewController alloc]init];
    hongbaoVC.title=@"如何获取红包？";
    [self.navigationController pushViewController:hongbaoVC animated:YES];
}
- (void) isDisplayPlusHold:(NSInteger)num
{
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
    }
}

@end
