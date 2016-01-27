//
//  ZKSelfMessageViewController.m
//  huihao
//
//  Created by 张坤 on 15/12/7.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSelfMessageViewController.h"
#import "ZKSlefMessageViewCell.h"
@interface ZKSelfMessageViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
static NSString *MessageID = @"selfMessageCell";
@implementation ZKSelfMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.加载网络数据
    [self setupHTTPData];
    //2. 初始化tableviewui
    [self setupTableUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTableUI
{
    [self.tableView registerNib:[UINib  nibWithNibName:@"ZKSlefMessageViewCell"  bundle:nil]forCellReuseIdentifier:MessageID];
}
- (void)setupHTTPData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@---%@",self.doctorModel.doctorId,userModel.sessionId);
    NSDictionary *params=@{
                           @"sessionId":userModel.sessionId
                           };
    [MBProgressHUD showMessage: LoaderString(@"httpLoadText")];
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/getMessageList.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        //[self.tableView.footer endRefreshing];
        NSLog(@"%@",json);
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        
        [self isDisplayPlusHold:data.count];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        //[self.tableView.footer endRefreshing];
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKSlefMessageViewCell *cell=[tableView dequeueReusableCellWithIdentifier:MessageID forIndexPath:indexPath];
   
    return cell;
}

- (void) isDisplayPlusHold:(NSInteger)num
{
    // self.tableView.tableFooterView=[[UIView alloc]init];
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
    }
}


@end
