//
//  ZKSelfTopicViewController.m
//  huihao
//
//  Created by 张坤 on 16/1/8.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKSelfTopicViewController.h"
#import "MJRefresh.h"
#import "ZKMyTopicViewCell.h"
#import "ZKTopicModel.h"
#import "ZKMeSpeakViewController.h"

@interface ZKSelfTopicViewController ()
@property (nonatomic,assign) int pageNext;
@property (nonatomic,assign) NSInteger allCount;
@property (strong, nonatomic)  NSMutableArray *dataSource;
@end

@implementation ZKSelfTopicViewController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //2.上啦
    [self setupDownLoad];
    //3.下拉
    [self setupUpLoad];

}
/**
 *  2. 下啦加载
 */
- (void)setupUpLoad
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDataSource)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  3. 上啦加载
 */
- (void)setupDownLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshBackNormalFooter *footer= [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupUpHttpData)];
    self.tableView.mj_footer=footer;
}
- (void)reloadDataSource
{
    //1. 初始化评论数据
    self.pageNext = 1;
    [self setupDownHttpData];
}
- (void)setupDownHttpData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel!=NULL) {
        params[@"sessionId"]=userModel.sessionId;
    }
    
    params[@"pageNumber"] =[NSString stringWithFormat:@"%d",self.pageNext];
    
    [ZKHTTPTool POST: [self setupUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        if ([ZKCommonTools JudgeState:json controller:nil]) {

            [self.dataSource removeAllObjects];
            
            self.allCount = [[[json objectForKey:@"body"] objectForKey:@"rowCount"] integerValue];
            NSArray *jsonData= [[json objectForKey:@"body"] objectForKey:@"data"];
            
            NSArray *data= [ZKTopicModel mj_objectArrayWithKeyValuesArray:jsonData];
    
            [self isDisplayPlusHold:data.count];
            
            [self.dataSource addObjectsFromArray:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            self.pageNext=2;
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)setupUpHttpData {
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==NULL) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 调用子类实现的方法
   // [self setupParams:params];
    params[@"pageNumber"] =[NSString stringWithFormat:@"%d",self.pageNext];
    params[@"sessionId"]=userModel.sessionId;
    
    NSLog(@"%@",params);
    
    [ZKHTTPTool POST:[self setupUrl] params:params success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            NSLog(@"%@",json);
            NSArray *data= [ZKTopicModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"] objectForKey:@"data"]];
            
            self.allCount = [[[json objectForKey:@"body"] objectForKey:@"rowCount"] integerValue];
            
            [self.dataSource addObjectsFromArray:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            self.pageNext++;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

# pragma 初始化要显示的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSource.count >= self.allCount) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    return self.dataSource.count;
}
#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKMyTopicViewCell *cell=[ZKMyTopicViewCell tagCellWithTableView:tableView];
    ZKTopicModel *topic = self.dataSource[indexPath.row];
    cell.topicModel = topic;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKTopicModel *topic=self.dataSource[indexPath.row];
    return topic.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
};
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKMeSpeakViewController *speakVC=[[ZKMeSpeakViewController alloc]init];
    ZKTopicModel *topic=  self.dataSource[indexPath.row];
    speakVC.title=@"话题详情";//topic.nickName;
    speakVC.topicModel=topic;
    [self.navigationController pushViewController:speakVC animated:YES];
}


- (NSString *)setupUrl
{
    return [NSString stringWithFormat:@"%@inter/wenzhang/listMyTopic.do",baseUrl];
}

- (void) isDisplayPlusHold:(NSInteger)num
{
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
    }
}
@end
