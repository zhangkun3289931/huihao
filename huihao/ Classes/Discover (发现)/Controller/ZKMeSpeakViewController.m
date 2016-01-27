//
//  ZKMeSpeakViewController.m
//  ;
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//
#import "ZKMeSpeakViewController.h"
#import "ZKUserTool.h"
#import "ZKHTTPTool.h"
#import "ZKTopicModel.h"
#import "MBProgressHUD+MJ.h"
#import "ZKTopicTableViewCell.h"
#import "ZKComposeViewController.h"
#import "ZKNavViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "ZKCommonTools.h"
#import "MJRefresh.h"
#import "ZKConst.h"
#import "ZKAnswerCell.h"
#import "ZKLoginViewController.h"
#import "IQKeyboardManager.h"
//#import "KeyboardToolBar.h"
#import "YFInputBar.h"
#import "huihao.pch"
#import "ZKUserTool.h"

@interface ZKMeSpeakViewController () <ZKAnswerCellDelegate,YFInputBarDelegate>
@property (strong, nonatomic)  NSMutableArray *dataSource;

@property (strong, nonatomic)  UIButton *button;
@property (nonatomic,assign) NSInteger pageNext;
@property (nonatomic,strong)  MJRefreshBackNormalFooter *footer;
@property (nonatomic,strong)  YFInputBar *inputBar;
@property (nonatomic,assign)  BOOL isNick;


@property (nonatomic,strong)  NSString *articleUserId;
@end

@implementation ZKMeSpeakViewController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //1.初始化NAV
    [self setUpNav];
    //3.下啦刷新
    [self setupDownLoad];
    //4.上啦加载
    [self setupUpLoad];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.inputBar removeFromSuperview];
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self.inputBar];
}
- (YFInputBar *)inputBar
{
    if (!_inputBar) {
        _inputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0,self.view.height+44, self.view.width, 44)];
        [_inputBar setBackgroundColor:[UIColor whiteColor]];
        _inputBar.delegate = self;
        _inputBar.clearInputWhenSend = YES;
        _inputBar.resignFirstResponderWhenSend = YES;
    }
   return  _inputBar;
}

/**
 *  5. 上啦加载
 */
- (void)setupUpLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshBackNormalFooter *footer= [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setUpCData)];
    self.footer=footer;
    self.tableView.mj_footer=footer;
}
/**
 *  下啦加载
 */
- (void)setupDownLoad
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDownHttpData)];
    // 马上进入刷新状态
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)reloadDownHttpData
{
    
    
    [self setDownData];
}

- (void)setDownData
{
    self.pageNext=1;
    
    ZKUserModdel *userModel=[ZKUserTool user];
    
    NSString *sessionId = userModel.sessionId;
  
    if (sessionId.length == 0) {
        sessionId = @"";
    }
    
    NSDictionary *params=@{
                           @"articleId":self.topicModel.articleId,
                           @"sessionId":sessionId,
                           @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };

    [ZKHTTPTool POST: [NSString stringWithFormat:@"%@inter/wenzhang/listWenzhangpingjia.do",baseUrl] params:params success:^(id json) {
        
        //NSLog(@"%@",json);
        
        [self.tableView.mj_header endRefreshing];
        
        if ([ZKCommonTools JudgeState:json controller:nil]) {
             [self.dataSource removeAllObjects];
            
            self.articleUserId = [[json objectForKey:@"body"] objectForKey:@"articleUserId"];
            self.topicModel.commentCount  = [[[json objectForKey:@"body"] objectForKey:@"rowCount"] stringValue];
            
            [self.dataSource  addObjectsFromArray:[ZKTopicModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"] objectForKey:@"data"]]];

        
            [self reloadTable];
        }
        self.pageNext = 2;
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
- (void)setUpCData
{
    ZKUserModdel *userModel=[ZKUserTool user];

    NSString *sessionId = userModel.sessionId;
    
    if (sessionId.length == 0) {
        sessionId = @"";
    }
    
    NSDictionary *params=@{
                           @"articleId":self.topicModel.articleId,
                           @"sessionId":sessionId,
                           @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };
    [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/wenzhang/listWenzhangpingjia.do",baseUrl] params:params success:^(id json) {
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            
              NSLog(@"%@",json);
            //隐藏HUD
            [MBProgressHUD hideHUD];
            [self.tableView.mj_footer endRefreshing];
            
            self.topicModel.commentCount  = [[[json objectForKey:@"body"] objectForKey:@"rowCount"] stringValue];

            [self.dataSource  addObjectsFromArray:[ZKTopicModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"] objectForKey:@"data"]]];
      
            
            [self reloadTable];
            self.pageNext++;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
         [MBProgressHUD showError:@"网络异常"];
    }];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void) setUpNav
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(CollectAction)];
    
    self.tableView.delegate=self;
    
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 44, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
  
}
#pragma mark - Table view data source

# pragma 初始化要显示的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    if (self.dataSource.count >= self.topicModel.commentCount.integerValue) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    return self.dataSource.count + 1;
}

#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        ZKTopicTableViewCell *cell=[ZKTopicTableViewCell cellWithTableView:tableView];
        cell.topic=self.topicModel;
        return cell;
    }
    else
    {
        ZKAnswerCell  *cell=[ZKAnswerCell cellWithTableView:tableView];
        cell.delegate=self;
        cell.articleUserId = self.articleUserId;
        cell.topic=self.dataSource[indexPath.row-1];
        return cell;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKTopicModel *topic;
    if (indexPath.row==0) {
        topic=self.topicModel;
        return topic.cellHeight;
    }
    else
    {
       topic=self.dataSource[indexPath.row-1];
        return topic.cellHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)composeViewController:(ZKComposeViewController *)vc
{
    [self setDownData];
}
#pragma mark -cellDelegate  点击采纳之后刷新数据
- (void)caiNaAnswer:(ZKAnswerCell *)answer withButton:(UIButton *)button
{
    self.topicModel.solveState = 1;
    
    self.topicModel.adoptState = 1;
    
    [ZKNotificationCenter postNotificationName:ZKTopicPublishSuccessNotification object:nil];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)answerCellNoLogin:(ZKAnswerCell *)cell {
    ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
    [self.navigationController presentViewController:login animated:YES completion:nil];
}
- (void)inputBar:(YFInputBar *)inputBar nickBtnPress:(UIButton *)nickBtn
{
    self.isNick = nickBtn.isSelected;
}
-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    if (str.length==0) {
        [MBProgressHUD showSuccess:@"内容不能为空"];
        return;
    }
    
    [self sendInfo:str];
}
//发送数据
- (void)sendInfo:(NSString *)info
{
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==nil) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    [params setValue:userModel.userId forKey:@"userId"];
    [params setValue:self.topicModel.articleId forKey:@"articleId"];
    [params setValue:info forKey:@"commentContent"];
    [params setValue:@" " forKey:@"articleTitle"];
    [params setValue:@(self.isNick) forKey:@"anonymous"];
    [self composeType:[NSString stringWithFormat:@"%@inter/wenzhang/addWenzhangpingjia.do",baseUrl] params:params];
    
   // NSLog(@"%@",params);
}
- (void)composeType:(NSString *)url params:(NSDictionary *)params
{
    [ZKHTTPTool POST:url params:params success:^(id json) {
        if ([ZKCommonTools JudgeState:json controller:nil]){
            [MBProgressHUD showMessage:@"发表成功"];
        
           // NSLog(@"%@",json);
            [self setDownData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.inputBar resignFirstResponder];
}
//收藏
- (void)CollectAction
{
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    ZKUserModdel *userModel=[ZKUserTool user];
    
    NSString *sessionId = userModel.sessionId;
    if (sessionId.length != 0) {
        params[@"sessionId"] = sessionId;
    }
    params[@"articleId"] = self.topicModel.articleId;
    
    [ZKHTTPTool POST: [NSString stringWithFormat:@"%@inter/wenzhang/addMyCollection.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        if ([ZKCommonTools JudgeState:json controller:nil]) {
           NSString *state= [[json objectForKey:@"state"] description];
            if([state isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"收藏成功"];
            }
        }
    } state:^(NSString *state) {
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    } andController:self];

}
@end
