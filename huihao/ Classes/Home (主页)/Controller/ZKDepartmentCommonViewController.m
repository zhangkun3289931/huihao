//
//  ZKCommonTableViewController.m
//  huihao
//
//  Created by Alex on 15/9/16.
//  Copyright (c) 2015年 张坤. All rights reserved.
//
#import "ZKDepartmentCommonViewController.h"
#import "ZKCommonHeaderView.h"
#import "ZKCommentModel.h"
#import "ZKHTTPTool.h"
#import "ZKUserTool.h"
#import "ZKCommonDepartmentViewCell.h"
#import "ZKLoginViewController.h"
#import "ZKGetConmmentViewController.h"
#import "ZKpennantsViewController.h"
#import "ZKNavViewController.h"
#import "ZKDetialViewController.h"
#import "ZKTongyuQiangViewController.h"
#import "ZKCommentButton.h"
#import "MJRefresh.h"
#import "ZKKeShiCommonModel.h"
#import "ZKKeShiDetialModel.h"
#import "ZKSegmentControl.h"
#import "ZKTopicViewController.h"
#import "ZKSearchHotModel.h"
#import "ZKCommonToolBarView.h"
#import "UILabel+ZKAlertActionFont.h"

@interface ZKDepartmentCommonViewController () <ZKCommonHeaderViewDelegate,ZKCommonViewCellDelegate,ZKCommonToolBarViewDelegate>
@property (nonatomic, strong) NSMutableArray *commentDataSource;
@property (nonatomic, strong) ZKSegmentControl *segmentControl;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,assign) CGFloat currentLoaction;

@property (nonatomic,strong) NSDictionary *diseaseMap;
@property (nonatomic,strong) ZKKeShiCommonModel *commonModel;
@property (nonatomic,assign) int pageNext;
//是否关注接口
@property (nonatomic, assign) BOOL isConcern;
@property (nonatomic,strong) ZKCommonHeaderView *headerView;
@property (nonatomic,strong) NSString  *flagCount;
@property (nonatomic,strong) ZKKeShiDetialModel *keshiDetial;
@property (nonatomic, strong) NSString *hospitalBrief;
@property (nonatomic, strong) NSString *concernCount;
@property (nonatomic,assign) NSInteger rowCount;


@end

@implementation ZKDepartmentCommonViewController



- (NSMutableArray *)commentDataSource
{
    if (!_commentDataSource) {
        _commentDataSource=[NSMutableArray array];
    }
    return _commentDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.初始化UI
    [self setupUI];

    //3.添加下拉加载
    [self setupDownLoad];

    //4.添加上拉加载
    [self setupUpLoad];

    //5. 添加手势
    [self addSwipe];


}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //2.加载科室详情数据
    [self setupKeShiDetialData];
}

- (void)setupUI{
    ZKCommonHeaderView *headerView=[ZKCommonHeaderView commonHeaderView];

    headerView.frame    = CGRectMake(0, 0, self.view.width, 144);
    headerView.delegate = self;

    self.headerView = headerView;

    self.tableView.tableHeaderView = headerView;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];

}
/**
 *  下啦加载
 */
- (void)setupDownLoad
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHttpData)];

    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];

}
- (void)reloadHttpData
{
    self.pageNext = 1;
    //1. 初始化评论数据
    self.currentIndex = self.segmentControl.selectedSegmentIndex;
    [self setupDownHttpData:[NSString stringWithFormat:@"%zd",self.currentIndex]];//0表示全部评价
   // [self.tableView.mj_header endRefreshing];

}

/**
 *  上啦加载
 */
- (void)setupUpLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
    self.tableView.mj_footer = footer;
}
- (void)upLoadData
{
     [self setupUpHttpData:[NSString stringWithFormat:@"%zd",self.currentIndex]];
}
/**
 *  下拉刷新科室评论数据
 *
 *  @param pitype
 */
- (void)setupDownHttpData:(NSString *)pitype
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionId = userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@"";
    }
     NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"departmentId":self.keshiModel.departmentId,
                           @"pjType":@(pitype.integerValue),
                           @"pageNumber":[NSString stringWithFormat:@"%d",self.pageNext]
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/listKeshipingjia.do",baseUrl] params:params success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        //NSLog(@"%@",json);
        
        if ( [ZKCommonTools JudgeState:json controller:nil]) {
            [self.commentDataSource removeAllObjects];

            NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];

            self.rowCount =[[[json  objectForKey:@"body"]objectForKey:@"rowCount"] integerValue];

            [self isDisplayPlusHold:data.count];

            [self.commentDataSource addObjectsFromArray:[ZKCommentModel mj_objectArrayWithKeyValuesArray:data]];
            [self.tableView reloadData];
            self.pageNext = 2;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        
        [self.commentDataSource removeAllObjects];
        [self isDisplayPlusHold:0];

    }];
}
/**
 *  上拉加载科室评论数据
 *
 *  @param pitype
 */
- (void)setupUpHttpData:(NSString *)pitype
{
    ZKUserModdel *userModel=[ZKUserTool user];

    NSString *sessionId = userModel.sessionId;

    if (userModel==NULL) {
        sessionId=@"";
    }

    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"departmentId":self.keshiModel.departmentId,
                           @"pjType":pitype,
                           @"pageNumber":[NSString stringWithFormat:@"%d",self.pageNext]
                           };

    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/listKeshipingjia.do",baseUrl] params:params success:^(id json) {
        [self.tableView.mj_footer endRefreshing];

        if ( [ZKCommonTools JudgeState:json controller:nil]) {
            NSArray *data = [[json objectForKey:@"body"]objectForKey:@"data"];

           self.rowCount = [[[json  objectForKey:@"body"]objectForKey:@"rowCount"] integerValue];

            [self.commentDataSource addObjectsFromArray:[ZKCommentModel mj_objectArrayWithKeyValuesArray:data]];

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

#define mark -commonHeaderDelegate
- (void)commonHeaderButtonClick:(ZKCommonHeaderView *)common
{
    ZKDetialViewController *detial=[[ZKDetialViewController alloc]init];

    detial.title=[NSString stringWithFormat:@"%@简介",self.keshiDetial.hospitalName];

    detial.hospitalBrief = self.hospitalBrief;

    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:detial];

    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -commonHeaderJnqiButtonClickDelegate
- (void)commonHeaderJnqiButtonClick:(ZKCommonHeaderView *)common
{
    [self pennantsClick];
}

- (void)pennantsClick
{
    ZKTongyuQiangViewController *jinqiVC=[[ZKTongyuQiangViewController alloc]init];
    ZKNavViewController *nav = [[ZKNavViewController alloc]initWithRootViewController:jinqiVC];
    jinqiVC.keshiModel = self.keshiModel;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


/**
 *  加载科室详情数据
 */
- (void)setupKeShiDetialData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionid=@"";
    if (userModel.sessionId!=NULL) {
        sessionid = userModel.sessionId;
    }
    
    NSDictionary *params=@{
                           @"sessionId":sessionid,
                           @"departmentId":self.keshiModel.departmentId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshi.do",baseUrl] params:params success:^(id json) {
        NSDictionary *data=[[[json objectForKey:@"body"]objectForKey:@"data"] firstObject];

        self.flagCount=[data objectForKey:@"flagCount"];

        self.isConcern = [[data objectForKey:@"concern"] boolValue];

        self.hospitalBrief=[data objectForKey:@"hospitalBrief"];

        self.concernCount=[data objectForKey:@"concernCount"];

        [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshiDetail.do",baseUrl] params:params success:^(id json) {

            NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];

            ZKKeShiDetialModel *keshiDetial = [[ZKKeShiDetialModel mj_objectArrayWithKeyValuesArray:data] firstObject];

            keshiDetial.flagCount = self.flagCount;

            keshiDetial.hospitalBrief = self.hospitalBrief;

            keshiDetial.concernCount = self.concernCount;

            self.headerView.keshiDetialModel = keshiDetial;

            self.keshiDetial = keshiDetial;

            [self reloadTable];

        } failure:^(NSError *error) {

            NSLog(@"%@",error.description);

        }];
    } failure:^(NSError *error) {

        NSLog(@"%@",error.description);

    }];
}
/**
 *  添加手势
 */
- (void)addSwipe
{
    // Recognizer 添加轻扫手势
    UISwipeGestureRecognizer *swipe;

    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeR:)];

    swipe.direction = UISwipeGestureRecognizerDirectionLeft;

    [self.tableView addGestureRecognizer:swipe];

    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeR:)];

    swipe.direction = UISwipeGestureRecognizerDirectionRight;

    [self.tableView addGestureRecognizer:swipe];
    
    // 添加长按手势
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
    
    [self.tableView addGestureRecognizer:longPressGesture];
}

- (void)swipeR:(UISwipeGestureRecognizer *)recognizer
{

    //// 1.初始化转场动画
    CATransition *transition = [[CATransition alloc]init];
    // 2.设置类型type
    [transition setType:@"rippleEffect"];
    //判断清扫的方向
    if (UISwipeGestureRecognizerDirectionLeft == recognizer.direction){
        
        self.segmentControl.selectedSegmentIndex = (self.segmentControl.selectedSegmentIndex + 1) % 3 ;
        
       [transition setSubtype:kCATransitionFromRight];
        
    } else if(UISwipeGestureRecognizerDirectionRight == recognizer.direction){
        
     self.segmentControl.selectedSegmentIndex = (self.segmentControl.selectedSegmentIndex - 1 + 3) % 3 ;
        [transition setSubtype:kCATransitionFromLeft];
    }
    self.currentIndex = self.segmentControl.selectedSegmentIndex;
    
   // [self setupDownHttpData:[NSString stringWithFormat:@"%zd",self.segmentControl.selectedSegmentIndex]];
    [self.tableView.mj_header beginRefreshing];
    
    // 3.设置时长
    transition.duration = 0.5f;
    
    [self.tableView.layer addAnimation:transition forKey:nil];

}

-(void)change:(UISegmentedControl *)segmentControl{
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)longPressGestureAction :(UILongPressGestureRecognizer *)resonginzer{
    
    if (resonginzer.state == UIGestureRecognizerStateBegan) {
        //1. 获取手指触摸的位置
        CGPoint locationPoint = [resonginzer locationInView:self.tableView];
        //2. 根据indexPathForRowAtPoint 返回tableView的indexPath
        NSIndexPath *locationIndexPath = [self.tableView indexPathForRowAtPoint:locationPoint];
        
        if (locationIndexPath != nil) {
            NSLog(@"长按的行号是：%ld",[locationIndexPath row]);
            [self showSheetViewWithLocationIndexPath:locationIndexPath];
        }
    }
}

- (void)showSheetViewWithLocationIndexPath:(NSIndexPath *)locationIndexPath{
    
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
//    for (int i = 0; i<count; i++) {
//        // 取出成员变量
//        Ivar ivar = *(ivars + i);
//        // 打印成员变量名字
//        NSLog(@"%s------%s", ivar_getName(ivar),ivar_getTypeEncoding(ivar));
//    }
//
    /*
     _title------@"NSString"
     _titleTextAlignment------q
     _enabled------B
     _checked------B
     _isPreferred------B
     _imageTintColor------@"UIColor"
     _titleTextColor------@"UIColor"
     _style------q
     _handler------@?
     _simpleHandler------@?
     _image------@"UIImage"
     _shouldDismissHandler------@?
     _descriptiveText------@"NSString"
     _contentViewController------@"UIViewController"
     _keyCommandInput------@"NSString"
     _keyCommandModifierFlags------q
     _representer------@"<UIAlertActionViewRepresentation_Internal>"
     _alertController------@"UIAlertController"
     */
    
    
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedInInstancesOfClasses:@[UIAlertController.class]];//[UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    [appearanceLabel setAppearanceFont:font];
    
    
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"" message:@"请选择举报的类型？" preferredStyle:UIAlertControllerStyleAlert];
  
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertSheet addAction:cancelAction];
    
    NSArray *reportTypetitls = @[ @"色情低谷"
                                 ,@"广告骚扰"
                                 ,@"诱导分享"
                                 ,@"谣言"
                                 ,@"政治敏感"
                                 ,@"违法（暴力恐怖、违禁品等）"
                                 ,@"其他（收集隐私信息等）"];
    
    for (int i=0; i<reportTypetitls.count; i++) {
        UIAlertAction *advertisementAction = [UIAlertAction actionWithTitle:reportTypetitls[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [MBProgressHUD showSuccess:reportTypetitls[i]];
        }];
        [alertSheet addAction:advertisementAction];
    }

    [self.navigationController presentViewController:alertSheet animated:YES completion:nil];
}

# pragma 初始化要显示的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.commentDataSource.count == self.rowCount)
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer resetNoMoreData];
    }

    return self.commentDataSource.count;
}
#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentDataSource.count == 0) { return nil; }

    ZKCommonDepartmentViewCell *cell=[ZKCommonDepartmentViewCell cellWithTableView:tableView];
    
    cell.delegate = self;

    cell.commentModel = self.commentDataSource[indexPath.row];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 79)];
    sectionView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.880];
    NSArray *toolBarTitles = @[@"送锦旗",@"关注",@"去评价"];
    ZKCommonToolBarView *toolBarView = [ZKCommonToolBarView commonToolBarView];
    toolBarView.toolBarTitles = toolBarTitles;
    toolBarView.isAttention = [NSString stringWithFormat:@"%d",self.isConcern];
    toolBarView.delegate = self;
    [sectionView addSubview:toolBarView];


    NSArray *array = @[@"全部评价",@"门诊评价",@"住院评价"];

    ZKSegmentControl *segmentControl=[[ZKSegmentControl alloc]initWithItems:array];

    segmentControl.frame = CGRectMake(0, 45, self.view.width, 34);
    //默认选择
    segmentControl.selectedSegmentIndex = self.currentIndex;
  
    //设置监听事件
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];

    self.segmentControl = segmentControl;

    [sectionView addSubview:segmentControl];

    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKCommentModel *model = self.commentDataSource[indexPath.row];

    return model.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 79;
}

#pragma mark -commonToolBarViewDelegate
-(void)commonToolBarView:(ZKCommonToolBarView *)commonToolBarView withClickItem:(ZKCommentButton *)item{
    [self commentClick:item];
}

- (void)commentClick:(ZKCommentButton *)button
{
    ZKUserModdel *userModel=[ZKUserTool user];

    if (userModel==nil) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }

    switch (button.tag) {
        case 0:
        {
            ZKpennantsViewController *getVC=[[ZKpennantsViewController alloc]init];

            getVC.title=@"送锦旗";

            getVC.keshiModel = self.keshiModel;

            getVC.flagCount  = self.flagCount;

            [self.navigationController pushViewController:getVC animated:YES];

            break;
        }
        case 1:
        {
            [self guanzhuKeshi:button];
            break;
        }

        case 2:
        {
            ZKGetConmmentViewController *getVC=[[ZKGetConmmentViewController alloc]init];

            getVC.title=[NSString stringWithFormat:@"评价%@",self.navigationItem.title];

            getVC.isKeshi = 1;

            getVC.keshiModel = self.keshiModel;

            getVC.doctorModel = self.doctorModel;

            [self.navigationController pushViewController:getVC animated:YES]
            ;
            break;
        }
        default:
            break;
    }
}
/**
 *  科室关注
 *
 *  @param button
 */
- (void)guanzhuKeshi:(UIButton *)button
{
    ZKUserModdel *userModel = [ZKUserTool user];
    
    NSString *sessionId = userModel.sessionId;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (sessionId.length != 0) {
        params[@"sessionId"] = sessionId;
    }
    
    params[@"departmentId"] = self.keshiModel.departmentId;
    params[@"departmentName"] = self.keshiModel.departmentTypeName;
    params[@"hospitalName"] = self.keshiModel.hospitalName;
    

    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/addKeshiGuanzhu.do",baseUrl]params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
        [button setTitle:@"已关注" forState:UIControlStateNormal];
        
        button.enabled = NO;
        
        self.isConcern = YES;
        
        NSInteger conNum = self.concernCount.integerValue+1;
        
        self.headerView.cornCount = conNum;
        
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"关注%@科室成功",self.keshiModel.departmentTypeName]];
        
    } state:nil failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    } andController:self];

}
/**
 *  是否显示hold
 *
 *  @param num
 *
 *  @return
 */
- (BOOL) isDisplayPlusHold:(NSInteger)num
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    if (num==0) {
        self.tableView.tableFooterView = [self.view showErrorView];
        return YES;
    }else
    {
        return NO;
    }
}

#pragma mark - commonViewDelegate

- (void)commonViewCellNoLogin:(ZKCommonDepartmentViewCell *)cell
{
    ZKLoginViewController *vc = [[ZKLoginViewController alloc]init];

    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (void)commonViewCellBingClick:(ZKCommonDepartmentViewCell *)cell withBingName:(NSString *)bingName
{
    ZKSearchHotModel *hotSearch = [[ZKSearchHotModel alloc]init];
    hotSearch.display = bingName;
    
    ZKTopicViewController *topicVC=[[ZKTopicViewController alloc]init];
    topicVC.title = hotSearch.display;
    topicVC.hotModel=hotSearch;
    [self.navigationController pushViewController:topicVC animated:YES];
    
}
@end
