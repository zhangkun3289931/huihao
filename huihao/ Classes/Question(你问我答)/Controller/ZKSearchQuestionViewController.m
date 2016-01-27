//
//  ZKSearchQuestionViewController.m
//  huihao
//
//  Created by 张坤 on 15/11/27.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSearchQuestionViewController.h"
#import "ZKHotSearchNewViewController.h"
#import "ZKSearchHotModel.h"
#import "ZKTopicViewController.h"
#import "ZKFileReadWriteTool.h"
#import "ZKConst.h"
#import "ZKSearchModel.h"
#import "ZKSearchHotModel.h"
//#import "KeyboardToolBar.h"
#import "HWSearchBar.h"


@interface ZKSearchQuestionViewController ()<ZKComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源

@end

@implementation ZKSearchQuestionViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 初始化Nav
    [self setupNav];
    //2. 添加上啦刷新
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initDataSource)];
    [self.tableView.mj_header beginRefreshing];
    
}
- (void)setupNav{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [searchButton setBackgroundImage:[UIImage imageNamed:@"answer_search_bg1"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(0, 0, 250, 30);
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [searchButton setAdjustsImageWhenHighlighted:NO];
    searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchDown];
    
    self.navigationItem.titleView = searchButton;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"我要提问" style:UIBarButtonItemStylePlain target:self action:@selector(TopicBtn:)];
}
- (void)searchClick
{
    ZKHotSearchNewViewController *hotSearch = [[ZKHotSearchNewViewController alloc]init];
    ZKNavViewController *nav = [[ZKNavViewController alloc]initWithRootViewController:hotSearch];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)TopicBtn:(UIButton *)sender {
    
    [ZKUserTool judgeIsLogin               ];
    
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==nil) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }
    
    ZKComposeViewController *compose=[[ZKComposeViewController alloc]init];
    compose.delegate = self;
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:compose];
    compose.title=@"发表话题";
    
    //compose.colnmuModel = self.colnmuModel;
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)composeViewController:(ZKComposeViewController *)vc withBingName:(NSString *)bingName
{
    //[self.tableView.mj_header beginRefreshing];
    
    
    ZKTopicViewController *topicVC=[[ZKTopicViewController alloc]init];
    ZKSearchHotModel *hotModel = [[ZKSearchHotModel alloc]init];
    hotModel.display = bingName;
    topicVC.hotModel = hotModel;
    [self.navigationController pushViewController:topicVC animated:YES];

}

-(void)initDataSource
{
    NSDictionary *params = @{
                             @"limit":@10,
                             };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/wenzhang/hotSearch.do",baseUrl] params:params success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        
        [self.dataArray removeAllObjects];
        NSArray *data= [[json objectForKey:@"body"]objectForKey:@"data"];
        
        [self.dataArray addObjectsFromArray:[ZKSearchHotModel mj_objectArrayWithKeyValuesArray:data]];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
          [self isDisplayPlusHold:0];
        [MBProgressHUD showError:@"网络异常"];
    }];

}




#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        cell.textLabel.height=30;
        cell.textLabel.width=self.view.width;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }

    ZKSearchHotModel *hotSearch= self.dataArray[indexPath.row];
    
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
   
    cell.textLabel.text = hotSearch.display;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZKSearchHotModel *hotSearch=self.dataArray[indexPath.row];

    ZKTopicViewController *topicVC=[[ZKTopicViewController alloc]init];
    topicVC.title = hotSearch.display;
    topicVC.hotModel = hotSearch;
    [self.navigationController pushViewController:topicVC animated:YES];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}


- (void) isDisplayPlusHold:(NSInteger)num
{
    self.tableView.tableFooterView=[[UIView alloc]init];
    if (num==0) {
    
        self.tableView.tableFooterView = [self.view showErrorView];
    }
}

@end
