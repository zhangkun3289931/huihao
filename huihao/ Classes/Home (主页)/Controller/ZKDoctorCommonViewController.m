//
//  ZKDoctorCommonViewController.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.

#import "ZKDoctorCommonViewController.h"
#import "ZKDetialViewController.h"
#import "ZKUserTool.h"
#import "ZKHTTPTool.h"
#import "ZKDoctorModel.h"
#import "UIImageView+WebCache.h"
#import "ZKNavViewController.h"
#import "ZKCommentModel.h"
#import "ZKDoctorCommonViewCell.h"
#import "ZKDoctorCommonModel.h"
#import "ZKGetConmmentViewController.h"
#import "ZKXianhuaViewController.h"
#import "ZKSendXianHuaControllerViewController.h"
#import "ZKGetConmmentViewController.h"
#import "ZKCommentButton.h"
#import "MJRefresh.h"
#import "ZKDoctorModel.h"
#import "ZKLoginViewController.h"
#import "ZKSegmentControl.h"
#import "ZKTopicViewController.h"
#import "ZKSearchHotModel.h"
#import "ZKCommonToolBarView.h"
@interface ZKDoctorCommonViewController ()<ZKDoctorCommonViewCellDelegate,ZKDoctorCommonViewCellDelegate,ZKCommonToolBarViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *doctorIcon;
@property (weak, nonatomic) IBOutlet UILabel *doctoerKeshi;
@property (weak, nonatomic) IBOutlet UILabel *doctorYIyuan;
@property (weak, nonatomic) IBOutlet UILabel *doctorDetial;
@property (weak, nonatomic) IBOutlet UILabel *meiLizhiLb;
@property (weak, nonatomic) IBOutlet UILabel *doctorScore;
@property (weak, nonatomic) IBOutlet UILabel *doctorCount;
@property (weak, nonatomic) IBOutlet UILabel *doctorFenSi;
@property (weak, nonatomic) IBOutlet UIButton *doctorMoreBt;
- (IBAction)doctorMorClick:(UIButton *)sender;
@property (copy, nonatomic)  NSString *des;
@property (copy, nonatomic)  NSString *desAll;
@property (nonatomic, strong) ZKSegmentControl *segmentControl;
@property (nonatomic, strong) NSMutableArray *commentDataSource;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,assign) int pageNext;
@property (strong, nonatomic) IBOutlet UILabel *fenshiLabel;
//是否关注接口
@property (nonatomic, assign) int concern;
@property (nonatomic,strong)  MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) NSString *doctorName;
@property (nonatomic, assign) NSInteger isAttention;
- (IBAction)meilizhiAction:(UIButton *)sender;

@end
@implementation ZKDoctorCommonViewController
- (NSMutableArray *)commentDataSource
{
    if (!_commentDataSource) {
        _commentDataSource=[NSMutableArray array];
    }
    return _commentDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 初始化ui
    [self initUI];
    //2. 初始化下啦
    [self setupDownLoad];
    //3. 添加手势
    [self addSwipe];
    //4. 上拉
    [self setupUpLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //1.加载医生详情
    [self loadDcoterDetial];
    //查看医生是否被关注
    [self loadDcoterCore];
}
- (void)initUI
{
    self.tableView.tableFooterView=[[UIView alloc]init];
 
    
    self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]];
    self.headerView.contentMode = UIViewContentModeScaleToFill & UIViewContentModeTop;
    self.doctorIcon.layer.cornerRadius=self.doctorIcon.width*0.5;
    self.doctorIcon.layer.borderWidth=1;
    self.doctorIcon.layer.borderColor=QianIconBorderLVColor.CGColor;
    self.doctorIcon.layer.masksToBounds=YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
}

/**
 *  4.下啦加载
 */
- (void)setupDownLoad
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHttpData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
   
}

- (void)reloadHttpData
{
    self.pageNext=1;
    self.currentIndex = self.segmentControl.selectedSegmentIndex;
    
    //2.加载医生评论
    [self loadDownDoctorData:[NSString stringWithFormat:@"%zd",self.currentIndex]];
    
    //[self.tableView.mj_header endRefreshing];
}
/**
 *  5. 上啦加载
 */
- (void)setupUpLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshBackNormalFooter *footer= [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadUpData)];
    self.footer=footer;
    [self.footer setTitle:LoaderString(@"upLoadText") forState:MJRefreshStateIdle];
    self.tableView.mj_footer=footer;
}
- (void)loadUpData
{
    [self loadUpDoctorData:[NSString stringWithFormat:@"%zd",self.segmentControl.selectedSegmentIndex]];
}
/**
 *  加载医生详情
 */
- (void)loadDcoterDetial {
    NSDictionary *params=@{
                          @"doctorId":self.doctorModel.doctorId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getDoctorById.do",baseUrl] params:params success:^(id json) {
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        NSString *herefDes=[[json objectForKey:@"body"]objectForKey:@"des"];
        NSString *goodAt=[[json objectForKey:@"body"]objectForKey:@"goodAt"];
        //NSLog(@"%@",json);
        if (herefDes.length==0) {
            herefDes=@"暂无";
        }
        if (goodAt.length==0) {
            goodAt=@"暂无";
        }
        self.des=[NSString stringWithFormat:@"简介:%@",herefDes];
        self.desAll=[NSString stringWithFormat:@"医院:%@ \n\n科室:%@ \n\n个人简介:%@ \n\n擅长:%@",self.doctorModel.hospitalName,self.doctorModel.departmentName,herefDes,goodAt];
        self.doctorModel=[ZKDoctorModel mj_objectWithKeyValues:[data firstObject]];
        //初始化医生信息数据
        [self initDoctorData:self.doctorModel];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
    }];
}
/**
 *  查看医生是否被关注
 */
- (void)loadDcoterCore {
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *userId=@"";
    if (userModel!=NULL) {
        userId=userModel.userId;
    }
    NSDictionary *params=@{
                           @"doctorId":self.doctorModel.doctorId,
                           @"userId":userId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/viewDoctor.do",baseUrl] params:params success:^(id json) {

        NSString *temp =[[json objectForKey:@"body"]objectForKey:@"isAttention"];
        NSDictionary *num=[[json objectForKey:@"body"]objectForKey:@"num"];

        self.doctorFenSi.text=[NSString stringWithFormat:@"%@人",num];
        self.isAttention=temp.integerValue;
         [self reloadTable];
    } failure:^(NSError *error) {
        
    }];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)smileClick
{
    ZKXianhuaViewController *xianhuaVC=[[ZKXianhuaViewController alloc]init];
    ZKNavViewController *nav = [[ZKNavViewController alloc]initWithRootViewController:xianhuaVC];
    xianhuaVC.title = @"鲜花簇";
    xianhuaVC.doctorModel=self.doctorModel;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)initDoctorData:(ZKDoctorModel *)model
{
    [self.doctorIcon sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
    self.doctoerKeshi.text=model.departmentName;
    self.doctorYIyuan.text=model.hospitalName;
    
    NSString *desTemp = (self.des.length <25)? self.des:[self.des substringToIndex:25];
    self.doctorDetial.text=[NSString stringWithFormat:@"%@...更多",desTemp];
    
    self.doctorScore.text=[NSString stringWithFormat:@"%@分",model.totalScore];
    self.doctorCount.text=[NSString stringWithFormat:@"%@条",model.revalueNum];
    self.meiLizhiLb.text=model.smartValue;
}
/**
 * 下拉刷新医生评论数据
 *
 *  @param pitype
 */
- (void)loadDownDoctorData:(NSString *)pitype
{
    ZKUserModdel *userModel=[ZKUserTool user];
   //NSInteger pitypeInt=pitype.integerValue;
    NSString *sessionId=userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@"";
    }
    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"doctorId":self.doctorModel.doctorId,
                           @"pjType":pitype,
                           @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getDoctorEvaluateList.do",baseUrl] params:params success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        if ( [ZKCommonTools JudgeState:json controller:nil]) {
            
             [self.commentDataSource removeAllObjects];
            
            NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
            NSString *pageN=[[json objectForKey:@"body"]objectForKey:@"pageNext"];
            
            if (self.pageNext>pageN.integerValue) {
                [self.footer setTitle:LoaderString(@"upNODataText") forState:MJRefreshStateIdle];
            }
            [self isDisplayPlusHold:data.count];
            
            NSArray *adtaArray = [ZKDoctorCommonModel mj_objectArrayWithKeyValuesArray:data];
            
            [self.commentDataSource addObjectsFromArray:adtaArray];
            
            [self reloadTable];

            self.pageNext=2;
        }
    } failure:^(NSError *error) {
        [self.commentDataSource removeAllObjects];
        [self isDisplayPlusHold:0];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

/**
 *  加载医生评论数据
 *
 *  @param pitype
 */
- (void)loadUpDoctorData:(NSString *)pitype
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionId=userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@"";
    }
    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"doctorId":self.doctorModel.doctorId,
                           @"pjType":pitype,
                           @"pageNumber":[NSString stringWithFormat:@"%zd",self.pageNext]
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getDoctorEvaluateList.do",baseUrl] params:params success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        
        if ( [ZKCommonTools JudgeState:json controller:nil]) {
            NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
            NSString *pageN=[[json objectForKey:@"body"]objectForKey:@"pageCount"];
            if (self.pageNext>pageN.integerValue) {
                [self.footer setTitle:LoaderString(@"upNODataText") forState:MJRefreshStateIdle];
                return ;
            }
            [self.commentDataSource addObjectsFromArray:[ZKDoctorCommonModel mj_objectArrayWithKeyValuesArray:data]];
            [self reloadTable];
             self.pageNext++;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
# pragma 初始化要显示的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDataSource.count;
}
#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentDataSource.count==0) {
        return nil;
    }
    ZKDoctorCommonViewCell *cell=[ZKDoctorCommonViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.commentModel=self.commentDataSource[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=  [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 74)];
    sectionView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.880];
    NSArray *toolBarTitles = @[@"送鲜花",@"关注",@"去评价"];
    ZKCommonToolBarView *toolBarView = [ZKCommonToolBarView commonToolBarView];
    toolBarView.toolBarTitles = toolBarTitles;
    toolBarView.isAttention = [NSString stringWithFormat:@"%ld",self.isAttention];
  //  NSLog(@"===%d",self.isa);
    toolBarView.delegate = self;
    [sectionView addSubview:toolBarView];
    
    NSArray *array=@[@"全部评价",@"门诊评价",@"住院评价"];
    ZKSegmentControl *segmentControl=[[ZKSegmentControl alloc]initWithItems:array];
    segmentControl.frame=CGRectMake(0, 45, self.view.width, 34);
    //默认选择
    segmentControl.selectedSegmentIndex = self.currentIndex;
   
    //设置监听事件
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl=segmentControl;
    [sectionView addSubview:segmentControl];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKCommentModel *model=self.commentDataSource[indexPath.row];
    return model.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 79;
}
/**
 *  添加手势
 */
- (void)addSwipe
{
    // Swipe
    // 一个手势只能识别一个方向
    UISwipeGestureRecognizer *swipe;
    swipe= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeR:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipe];
    swipe= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeR:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipe];
}

- (void)swipeR:(UISwipeGestureRecognizer *)recognizer
{
    
    //// 1.初始化转场动画
    CATransition *transition = [[CATransition alloc]init];
    // 2.设置类型type
    [transition setType:@"rippleEffect"];
    //判断清扫的方向
    if (UISwipeGestureRecognizerDirectionLeft == recognizer.direction){
        
        
        //if (self.segmentControl.selectedSegmentIndex==3) { return; }
        
        self.segmentControl.selectedSegmentIndex = (self.segmentControl.selectedSegmentIndex + 1) % 3 ;
        
        [transition setSubtype:kCATransitionFromRight];
        
    } else if(UISwipeGestureRecognizerDirectionRight == recognizer.direction){
        
        // if (self.segmentControl.selectedSegmentIndex==0) { return; }
        self.segmentControl.selectedSegmentIndex = (self.segmentControl.selectedSegmentIndex - 1 + 3) % 3 ;
        [transition setSubtype:kCATransitionFromLeft];
    }
    //self.currentIndex = self.segmentControl.selectedSegmentIndex;
    
    //[self loadDownDoctorData:[NSString stringWithFormat:@"%zd",self.segmentControl.selectedSegmentIndex]];//0表示全部评价;
    [self.tableView.mj_header beginRefreshing];
    
    // 3.设置时长
    transition.duration = 0.5f;
    
    [self.tableView.layer addAnimation:transition forKey:nil];
    
    
}
-(void)change:(UISegmentedControl *)segmentControl {
   //  self.segmentControl.selectedSegmentIndex =
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)doctorMorClick:(UIButton *)sender {
    ZKDetialViewController *detial=[[ZKDetialViewController alloc]init];
    detial.title = [NSString stringWithFormat:@"%@简介",self.doctorModel.doctorName];
    detial.hospitalBrief = self.desAll;
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:detial];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -commonToolBarViewDelegate
-(void)commonToolBarView:(ZKCommonToolBarView *)commonToolBarView withClickItem:(ZKCommentButton *)item{
    [self commentClick:item];
}

- (void)commentClick:(UIButton *)button
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
            ZKSendXianHuaControllerViewController *getVC=[[ZKSendXianHuaControllerViewController alloc]init];
            getVC.title=@"送鲜花";
            getVC.doctorModel=self.doctorModel;
            [self.navigationController pushViewController:getVC animated:YES];
            break;
        }
        case 1:
        {
            [self guanzhuDoctor:button] ;
            break;
        }
            
        case 2:
        {
            ZKGetConmmentViewController *getVC=[[ZKGetConmmentViewController alloc]init];
            getVC.title=[NSString stringWithFormat:@"评价%@",self.navigationItem.title];
            getVC.doctorModel=self.doctorModel;
            getVC.isKeshi = 0;
            [self.navigationController pushViewController:getVC animated:YES]
            ;
            break;
        }
        default:
            break;
    }
}
- (void)guanzhuDoctor:(UIButton *)button
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionId=userModel.sessionId;
    if (userModel==NULL) {
        sessionId=@"";
    }
    NSDictionary *params=@{
                           @"sessionId":sessionId,
                           @"doctorId":self.doctorModel.doctorId,
                           @"doctorName":self.doctorModel.doctorName,
                           @"departmentName":self.doctorModel.departmentName,
                           @"hospitalName" : self.doctorModel.hospitalName
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/payAttentionToDoctor.do",baseUrl]params:params success:^(id json) {
        //NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
       
        [button setTitle:@"已关注" forState:UIControlStateNormal];
        [MBProgressHUD hideHUD];
        NSInteger tempFenshiCount=  self.doctorFenSi.text.integerValue+1;
        button.enabled = NO;
        self.isAttention = 1;
        self.doctorFenSi.text=[NSString stringWithFormat:@"%zd人",tempFenshiCount];
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"关注%@医生成功",self.doctorModel.doctorName]];
    }  state:^(NSString *state) {
        if ([state isEqualToString:@"-106"]) {
            ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
            [self.navigationController presentViewController:login animated:YES completion:nil];
        }
    }  failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        
    }];
}
- (IBAction)meilizhiAction:(UIButton *)sender {

    [self smileClick];
}
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
- (void)doctorViewCellNoLogin:(ZKDoctorCommonViewCell *)cell
{
    ZKLoginViewController *vc=[[ZKLoginViewController alloc]init];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)doctorViewCellWithBingClick:(ZKDoctorCommonViewCell *)cell bingName:(NSString *)bingName
{
    ZKSearchHotModel *hotSearch = [[ZKSearchHotModel alloc]init];
    hotSearch.display = bingName;
    
    ZKTopicViewController *topicVC=[[ZKTopicViewController alloc]init];
    topicVC.title = hotSearch.display;
    topicVC.hotModel=hotSearch;
    [self.navigationController pushViewController:topicVC animated:YES];
}
@end
