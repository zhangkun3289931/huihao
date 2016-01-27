//
//  ZKTopicViewController.m
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKTopicViewController.h"
#import "ZKHTTPTool.h"
@interface ZKTopicViewController ()<ZKComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet   UISegmentedControl *segmentController;
- (IBAction)segAction:(UISegmentedControl *)sender;

@end

@implementation ZKTopicViewController
- (void)setColnmuModel:(ZKColumuModel *)colnmuModel
{
    _colnmuModel = colnmuModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.title = self.hotModel.display;
    
    //1.初始化ui
    [self setupNav];

}

- (void)dealloc
{
    [ZKNotificationCenter removeObserver:self];
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"我要提问" style:UIBarButtonItemStylePlain target:self action:@selector(TopicBtn:)];
    
    [ZKNotificationCenter  addObserver:self selector:@selector(topicPublishAction:) name:ZKTopicPublishSuccessNotification object:nil];
}

- (void)topicPublishAction:(NSNotification *)notification
{
   [self.tableView.mj_header beginRefreshing];
}

- (void)setupParams:(NSMutableDictionary *)params
{
    // 城市
    params[@"searchKey"] = self.hotModel.display;

    // 分类(类别)
    params[@"solveState"] = [NSString stringWithFormat:@"%zd",self.segmentController.selectedSegmentIndex];
}
- (NSString *)setupUrl
{
    return [NSString stringWithFormat:@"%@inter/wenzhang/listWenzhang.do",baseUrl];
}
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSData *data =[input dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
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

    compose.colnmuModel = self.colnmuModel;

    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)segAction:(UISegmentedControl *)sender {

    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];

    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        if (status == AFNetworkReachabilityStatusNotReachable ) {
            NSLog(@"没有网络(断网)");
            [MBProgressHUD showError:@"网络未连接"];
    self.segmentController.selectedSegmentIndex = !self.segmentController.selectedSegmentIndex;
            return ;
        }
    }];

    // 3.开始监控
    [mgr startMonitoring];

    [self.tableView.mj_header beginRefreshing];
}


- (void)composeViewController:(ZKComposeViewController *)vc withBingName:(NSString *)bingName
{
    self.segmentController.selectedSegmentIndex = 0;
    self.title = bingName;
    ZKSearchHotModel *hotModel = [[ZKSearchHotModel alloc]init];
    hotModel.display = bingName;
    self.hotModel = hotModel;
    [self.tableView.mj_header beginRefreshing];
   }
@end
