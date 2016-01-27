//
//  ZKHomeViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/14.
//  Copyright (c) 2015年 张坤. All rights reserved.


#import "ZKHomeViewController.h"
#import "ZKKeshiTableViewCell.h"
#import "ZKDoctorTableViewCell.h"
#import "ZKDepartmentCommonViewController.h"
#import "ZKDoctorCommonViewController.h"
#import "ZKSearchControllerController.h"
#import "ZKGetConmmentViewController.h"
#import "ZKAddDoctorViewController.h"
#import "ZKAddDepartmentViewController.h"
#import "ZKLoginViewController.h"
#import "ZKFileReadWriteTool.h"
#import "ZKJudgeCommentTool.h"
#import "ZKDropMenuView.h"
#import "ZKRegionTool.h"
#import "ZKBingTool.h"
#import "ZKBingModel.h"
#import "ZKKeShiTool.h"
#import "ZKPaiXuModel.h"
#import "MJRefresh.h"
#import "ZKConst.h"


#define UICellHeadHeight  35

@interface ZKHomeViewController()<ZKDoctorTableViewCellDelegate,ZKKeshiTableViewCellDelegate,HWSearchControllerDelegate,ZKDropdownMenuViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *dropMenuView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addDoctorOrDeparment;
@property (strong, nonatomic) IBOutlet UIView *footView;

- (IBAction)addDoctorOrDeparmentClick:(UIButton *)sender;

@property (nonatomic,strong) NSMutableArray *regionDataSource;
@property (nonatomic,strong) NSMutableDictionary *regionDictChuLi;
@property (nonatomic,strong) NSMutableArray *bingDataSource;
@property (nonatomic,strong) NSMutableDictionary *bingDictChuLi;
@property (nonatomic,strong) NSMutableArray *keshiDataSource;
@property (nonatomic,strong) NSMutableDictionary *keshiDictChuLi;
@property (nonatomic,strong) NSMutableArray *searchDataSourceChuLi;
@property (nonatomic,strong) NSArray *PaiXuDataSource;
@property (nonatomic,strong) NSMutableDictionary *PaiXuDataSourceChuLi;

@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSMutableArray *resultKeshiDataSouce;
@property (nonatomic, copy) NSMutableArray *resultDoctorDataSouce;

@property (nonatomic,copy) NSString *diseaseId;
@property (nonatomic,copy) NSString *areaID;
@property (nonatomic,copy) NSString *departmentTypeId;
@property (nonatomic,copy) NSString *order;
@property (nonatomic,strong) NSMutableArray *titles;

@property (nonatomic,assign) int pageNext;

@property (nonatomic,assign) NSInteger rowCount;

@property (nonatomic, assign) NSInteger isFirst;

@property (nonatomic,strong)  MJRefreshAutoStateFooter *footer;


@property (nonatomic,strong) UIButton *searchButton;
@end
@implementation ZKHomeViewController

#pragma mark -系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];

    //0.判断服务器是否重启
    [ZKUserTool judgeIsLogin];

    //1.初始化nav
    [self setupNav];

    //3. 加载数据
    [self setupUpLoad];

    //4.初始化下啦刷新
    [self setupDownLoad];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //2.初始化菜单数据
    [self setupMenuInfo];
}

#pragma mark -初始化一些数据
//初始化menu信息
- (void)setupMenuInfo
{
    //1. 初始化地区信息
    [self setupRegionData];

    //2. 初始化病种信息
    [self setupBingData];

    //3. 初始化科室信息
    [self setupKeshiData];

    //4. 初始化排序信息
    [self setupPaixuData];
    
    //5. 初始化dropMenuView
    [self setupMenuView];

}

- (void)setupMenuView{
    ZKDropMenuView *dropMenuView = [[ZKDropMenuView alloc]initWithFrame:self.dropMenuView.bounds];
    dropMenuView.delegate = self;
    dropMenuView.displayTitles = self.titles;
    dropMenuView.regionDictChuLi = self.regionDictChuLi;
    dropMenuView.keshiDictChuLi = self.keshiDictChuLi;
    dropMenuView.bingDictChuLi = self.bingDictChuLi;
    dropMenuView.PaiXuDataSourceChuLi = self.PaiXuDataSourceChuLi;
    [self.dropMenuView addSubview:dropMenuView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //3.初始化医院排序
    if (self.segmentedControl.selectedSegmentIndex==ZKHomeViewKeshi) {
        [self initKeshiPaizu];
    }else
    {
        [self initZhuYuanPaizu];
    }
    
    self.navigationController.navigationBarHidden = NO;
    
}
/**
 *  初始化Nav
 */
- (void)setupNav
{
    //1.设置tableView
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //2.初始化UISegmentedControl
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"科室排行",@"医生排行",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    [segmentedControl setTintColor:[UIColor whiteColor]];

    segmentedControl.selectedSegmentIndex = ZKHomeViewKeshi ;//设置默认选择项索引
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    [self segmentAction:segmentedControl];
    self.segmentedControl = segmentedControl;
    self.navigationItem.titleView = segmentedControl;

    
    //0.加载中
    //[MBProgressHUD showMessage:LoaderString(@"httpLoadText")];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton = searchButton;
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    searchButton.frame = CGRectMake(0, 0, 70, 44);
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [searchButton setShowsTouchWhenHighlighted:NO];
    [searchButton addTarget:self action:@selector(searchCllick) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:searchButton];

}
#pragma mark -segmentAction的响应方法
-(void)segmentAction:(UISegmentedControl *)Seg{

    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];

    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        if (status == AFNetworkReachabilityStatusNotReachable ) {
            NSLog(@"没有网络(断网)");
            [MBProgressHUD showError:@"网络未连接"];
            self.segmentedControl.selectedSegmentIndex = 0;
            return ;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
 
    //3.初始化医院排序
    if (Seg.selectedSegmentIndex==ZKHomeViewKeshi) {
        [self.addDoctorOrDeparment setTitle:@"添加科室" forState:UIControlStateNormal];

        [self initKeshiPaizu];
    }else
    {
        [self.addDoctorOrDeparment setTitle:@"添加医生" forState:UIControlStateNormal];

        [self initZhuYuanPaizu];
    }

    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchResult = @"";

    [ZKNotificationCenter postNotificationName:ZKHomeSegSwitchNotification object:nil userInfo:nil];

}
/**
 *  搜索框
 */
- (void)searchCllick
{
    //3. 跳转到搜索界面
    ZKSearchControllerController *searchBar=[[ZKSearchControllerController alloc]init];
    searchBar.isSerach = (self.searchResult.length == 0);
    searchBar.delegate = self;
    searchBar.selectSugIndex = self.segmentedControl.selectedSegmentIndex;
    searchBar.dataArray = self.searchDataSourceChuLi;
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:searchBar];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -加载列表数据
/**
 *  4. 上啦加载更多数据
 */
- (void)setupUpLoad
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadUpMoreData)];
    self.footer = footer;
    
    self.tableView.mj_footer = footer;
}
/**
 *  5. 下拉刷新数据
 */
- (void)setupDownLoad
{
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDropMoreData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];

}
/**
 *  下拉刷新数据
 */
- (void) loadDropMoreData
{
    self.pageNext = 1;
    //[self .tableView reloadData];
    //[self.tableView.mj_header endRefreshing];
    //[self.tableView.mj_footer endRefreshing];

   if(self.segmentedControl.selectedSegmentIndex==ZKHomeViewKeshi)
   {
       [self downLoadKeshiData];
   }
    else
    {
        [self downLoadDoctorData];
    }
}
/**
 *  上拉加载数据
 */
- (void) loadUpMoreData
{
    if(self.segmentedControl.selectedSegmentIndex==ZKHomeViewKeshi)
    {
        [self upLoadKeshiData];
    }
    else
    {
        [self upLoadDoctorData];
    }

}
/**
 *  加载参数
 *
 *  @return
 */
- (NSMutableDictionary *)loadParams
{
    NSMutableDictionary *paras=[NSMutableDictionary dictionary];
    if (self.diseaseId.length>0) {
        [paras setValue:self.diseaseId forKey:@"diseaseId"];
    }
    if (self.areaID.length>0) {
        [paras setValue:self.areaID forKey:@"areaId"];
    }
    if (self.departmentTypeId.length>0) {
        [paras setValue:self.departmentTypeId forKey:@"departmentTypeId"];
    }
    if (self.order.length>0) {
        [paras setValue:self.order forKey:@"order"];
    }
    if (self.pageNext>0) {
        [paras setValue:@(self.pageNext) forKey:@"pageNumber"];
    }
    if (self.searchResult.length>0){
        [paras setValue:self.searchResult forKey:@"searchKey"];
    }

    [paras setValue:[NSString stringWithFormat:@"%zd",self.isFirst] forKey:@"isFirst"];

    return paras;
}

- (void)judgeFootViewDisplay :(NSMutableArray *)arrayM{
    if (self.rowCount == arrayM.count) {
        self.tableView.tableFooterView = self.footView;
    }else
    {
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
}

/**
 *  下啦加载更多科室信息
 */
- (void)downLoadKeshiData
{
    NSMutableDictionary *paras = [self loadParams];

    [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/keshi/listKeshi.do",baseUrl] params:paras success:^(id json) {

        [self.tableView.mj_header endRefreshing];

        //移除之前的数据
        [self.resultKeshiDataSouce removeAllObjects];

        self.rowCount = [[[json objectForKey:@"body"]objectForKey:@"rowCount"] integerValue];

        NSString *resultType=[[json objectForKey:@"body"]objectForKey:@"resultType"];

        if (resultType.integerValue <2 && resultType != NULL ) {
            [ZKNotificationCenter postNotificationName:ZKHomeKeshiResutTypeNotification object:nil userInfo:@{@"resultType":resultType}];
        }

        NSArray *data = [ZKKeShiModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"]objectForKey:@"data"]];

        
        [self.resultKeshiDataSouce addObjectsFromArray:data];
      //  [self isDisplayPlusHold:data.count];
     
        [self judgeFootViewDisplay:self.resultKeshiDataSouce];
      
        if (data > 0) {
            [self reloadTable];
        }
        
        self.pageNext = 2;

    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
/**
 *  上拉刷新科室
 */
- (void)upLoadKeshiData
{
    [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/keshi/listKeshi.do",baseUrl] params:[self loadParams] success:^(id json) {
        [self.tableView.mj_footer endRefreshing];

        NSArray *data = [ZKKeShiModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"]objectForKey:@"data"]];

        self.rowCount = [[[json objectForKey:@"body"]objectForKey:@"rowCount"] integerValue];

        [self.resultKeshiDataSouce addObjectsFromArray:data];

        
        [self judgeFootViewDisplay:self.resultKeshiDataSouce];
        
        [self reloadTable];

        self.pageNext++;
    }  failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
/**
 *  下啦加载医生数据
 */
- (void)downLoadDoctorData
{
    NSMutableDictionary *paras = [self loadParams];
    NSLog(@"%@",paras);
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getDoctorsList.do",baseUrl] params:paras success:^(id json) {
        
        [self.tableView.mj_header endRefreshing];

        //移除之前的数据
        [self.resultDoctorDataSouce removeAllObjects];

        self.rowCount = [[[json objectForKey:@"body"]objectForKey:@"rowCount"] integerValue];
        
        NSString *resultType=[[json objectForKey:@"body"]objectForKey:@"resultType"];

        if (resultType.integerValue <2 && resultType != NULL ) {
            [ZKNotificationCenter postNotificationName:ZKHomeKeshiResutTypeNotification object:nil userInfo:@{@"resultType":resultType}];
        }

        NSArray *data=[ZKDoctorModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"]objectForKey:@"data"]];

        
        [self.resultDoctorDataSouce addObjectsFromArray:data];
        
        [self judgeFootViewDisplay:self.resultDoctorDataSouce];
    
        
        if (data > 0) {
             [self reloadTable];
        }
       
        self.pageNext = 2;
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

/**
 *  上拉刷新医生数据
 */
- (void)upLoadDoctorData
{
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/getDoctorsList.do",baseUrl] params:[self loadParams] success:^(id json) {
        [self.tableView.mj_footer endRefreshing];
        NSArray *data=[ZKDoctorModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"]objectForKey:@"data"]];
        self.rowCount = [[[json objectForKey:@"body"]objectForKey:@"rowCount"] integerValue];
        
        [self.resultDoctorDataSouce addObjectsFromArray:data];
        
        
        [self judgeFootViewDisplay:self.resultDoctorDataSouce];
        
        [self reloadTable];
        
        self.pageNext++;
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络异常"];
    }];
}


#pragma mark -tableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segmentedControl.selectedSegmentIndex==ZKHomeViewKeshi) {
        if (self.resultKeshiDataSouce.count == self.rowCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [self.tableView.mj_footer resetNoMoreData];
        }
        return self.resultKeshiDataSouce.count;
    }else
    {
        if (self.resultDoctorDataSouce.count == self.rowCount) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [self.tableView.mj_footer resetNoMoreData];
        }
        return self.resultDoctorDataSouce.count;
   }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index==ZKHomeViewKeshi)
    {
        if (self.resultKeshiDataSouce.count != 0) {
            ZKKeshiTableViewCell *cell=[ZKKeshiTableViewCell tagCellWithTableView:tableView];
            ZKKeShiModel *model = self.resultKeshiDataSouce[indexPath.row];
            cell.delegate = self;
            cell.keshiModel = model;
            return cell;
        }
    }else
    {
        if (self.resultDoctorDataSouce.count != 0) {
            ZKDoctorTableViewCell *cell=[ZKDoctorTableViewCell tagCellWithTableView:tableView];
            ZKDoctorModel *doctorModel = self.resultDoctorDataSouce[indexPath.row];
            cell.delegate = self;
            cell.doctorModel = doctorModel;
            return cell;
        }
    }
    return [[UITableViewCell alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    if (index==ZKHomeViewKeshi) {
        return 105;
    }else
    {
        return 85;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消tableViewCell选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;

    if(index==ZKHomeViewKeshi)
    {
        ZKDepartmentCommonViewController *test1=[[ZKDepartmentCommonViewController alloc]init];
        ZKKeShiModel *keshi = self.resultKeshiDataSouce[indexPath.row];
        test1.title = keshi.departmentTypeName;
        test1.keshiModel = keshi;

        [self.navigationController pushViewController:test1 animated:YES];
    }else
    {
        ZKDoctorCommonViewController *doctor=[[ZKDoctorCommonViewController alloc]init];
        ZKDoctorModel *doctorModel = self.resultDoctorDataSouce[indexPath.row];
        NSString *title = [NSString stringWithFormat:@"%@-%@",doctorModel.doctorName,doctorModel.position];
        if (doctorModel.position.length==0) {
            title = doctorModel.doctorName;
        }
        doctor.title = title;
        doctor.doctorModel = doctorModel;
        [self.navigationController pushViewController:doctor animated:YES];
    }
}
/**
 *  刷新tableView
 */
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -ZKDoctorTableViewCell
-(void)doctorTableViewCellWithClick:(ZKDoctorTableViewCell *)cell button:(UIButton *)button
{
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==NULL) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }

    ZKGetConmmentViewController *getVC=[[ZKGetConmmentViewController alloc]init];
    getVC.title=[NSString stringWithFormat:@"评价%@",cell.doctorModel.doctorName];
    getVC.doctorModel = cell.doctorModel;
    getVC.isKeshi = 0;
    [self.navigationController pushViewController:getVC animated:YES];
}

#pragma mark -ZKKeshiTableViewCell
-(void)keShiTableViewCellWithClick:(ZKKeshiTableViewCell *)cell button:(UIButton *)button
{
    ZKUserModdel *userModel=[ZKUserTool user];
    if (userModel==NULL) {
        ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
        return;
    }
    
    ZKGetConmmentViewController *getVC=[[ZKGetConmmentViewController alloc]init];
    getVC.title=[NSString stringWithFormat:@"评价%@",cell.keshiModel.departmentTypeName];
    getVC.isKeshi = 1;
    getVC.keshiModel = cell.keshiModel;
    
    [self.navigationController pushViewController:getVC animated:YES];
   
}

#pragma mark -ZKDropdownMenuViewDelegate
- (void)dropdownMenuViewWithItem:(ZKDropMenuView *)dropMenuView andTitleArray:(NSArray *)titles andFirst:(NSInteger)isFirst
{
    //1.添加约束条件
    self.areaID = titles[ZKDropDataTypeRegion];
    self.departmentTypeId = titles[ZKDropDataTypeKeshi];
    self.diseaseId = titles[ZKDropDataTypeBingZhong];
    self.order = titles[ZKDropDataTypePaiXu];
    self.isFirst = isFirst;
    
    //2.加载数据
    [self.tableView.mj_header beginRefreshing];
    
}
/**************************初始化menudrop*****************************************/

- (NSMutableArray *)resultKeshiDataSouce
{
    if (!_resultKeshiDataSouce) {
        _resultKeshiDataSouce=[NSMutableArray array];
    }
    return _resultKeshiDataSouce;
}
- (NSMutableArray *)resultDoctorDataSouce
{
    if (!_resultDoctorDataSouce) {
        _resultDoctorDataSouce=[[NSMutableArray alloc]init];
    }
    return _resultDoctorDataSouce;
}
- (NSMutableArray *)searchDataSourceChuLi
{
    if(!_searchDataSourceChuLi)
    {
        _searchDataSourceChuLi=[NSMutableArray array];
    }
    return _searchDataSourceChuLi;
}
- (NSMutableDictionary *)PaiXuDataSourceChuLi
{
    if (!_PaiXuDataSourceChuLi) {
        _PaiXuDataSourceChuLi=[NSMutableDictionary dictionary];
    }
    return _PaiXuDataSourceChuLi;
}
- (NSMutableArray *)titles
{
    if (!_titles) {
        [self loadTitle];
    }
    return _titles;
}
#pragma mark -setter方法
/**
 *  返回来的搜索关键字
 *
 *  @param searchResult
 */
- (void)search:(ZKSearchControllerController *)search clickTitle:(NSString *)title
{
    [self.resultDoctorDataSouce removeAllObjects];

    self.searchResult = title;
    
    if (title.length == 0) {
         [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    }else{
        [self.searchButton setTitle:title forState:UIControlStateNormal];
    }
    

    [ZKNotificationCenter postNotificationName:ZKHomeSegSwitchNotification object:nil userInfo:nil];
    
   
}

- (void) loadTitle
{
    _titles=[NSMutableArray array];
    [_titles addObject:@"全国"];
    [_titles addObject:@"科室"];
    [_titles addObject:@"病种"];
    [_titles addObject:@"智能排序"];
}
/**
 *  初始化地区信息
 */
- (void)setupRegionData
{
    NSArray *data =(NSArray *)[ZKFileReadWriteTool readArray:@"region.plist"];
    if (data==nil) {

        [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/zidian/diqu.do",baseUrl] params:nil success:^(NSDictionary *json) {
            //写入plist文件
    NSArray *data                              = [[json objectForKey:@"body"] objectForKey:@"data"];
            [ZKFileReadWriteTool writeArray:data fileName:@"region.plist"];
            [self chuLiRegion:data];
        }  failure:^(NSError *error) {
        }];
    }else
    {
         [self chuLiRegion:data];
    }
}
- (void)chuLiRegion:(NSArray *)data{
    self.regionDataSource=(NSMutableArray *)[ZKRegionModel mj_objectArrayWithKeyValuesArray:data];

    self.regionDictChuLi=[NSMutableDictionary dictionary];
    NSMutableArray *regionArrayM=[NSMutableArray array];
    NSString *prePro;
    for (ZKRegionModel *regionModel in  self.regionDataSource) {
        if (![regionModel.szm isEqualToString:prePro]) {

            prePro = regionModel.szm;
            [self.searchDataSourceChuLi addObject:regionModel.areaName];
            if (regionModel.szm==nil) {
                continue;
            }
            [regionArrayM addObject:prePro];
        }
    }

    for (NSString *szm in regionArrayM) {
        NSMutableArray *szmArray=[NSMutableArray array];
        for (ZKRegionModel *regionModel in  self.regionDataSource) {
            if ([szm isEqualToString:regionModel.szm]) {
                [szmArray addObject:regionModel];
                [self.regionDictChuLi setObject:szmArray forKey: szm];
            }
        }

    }

}
- (void)setupBingData
{
   NSArray *data=(NSArray *)[ZKFileReadWriteTool readArray:@"bing.plist"];
    if (data==nil) {
        [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/zidian/bingzhong.do",baseUrl] params:nil success:^(NSDictionary *json) {
            // NSLog(@"--%@",[[json objectForKey:@"body"] objectForKey:@"data"]);
            //写入plist文件
            NSArray *data = [[json objectForKey:@"body"] objectForKey:@"data"];
            [ZKFileReadWriteTool writeArray:data fileName:@"bing.plist"];
            [self chuLiBing:data];
        } failure:^(NSError *error) {

        }];
    }else{
        [self chuLiBing:data];
    }
}
- (void)chuLiBing:(NSArray *)data{

    self.bingDataSource=(NSMutableArray *)[ZKBingModel mj_objectArrayWithKeyValuesArray:data];
    self.bingDictChuLi=[NSMutableDictionary dictionary];
    NSMutableArray *bingArrayM=[NSMutableArray array];
    NSString *prePro;
    for (ZKBingModel *regionModel in  self.bingDataSource) {
        if (![regionModel.szm isEqualToString:prePro]) {

    prePro                                     = regionModel.szm;

            if (regionModel.szm==nil) {
                continue;
            }
            [bingArrayM addObject:prePro];
        }
    }

    // NSLog(@"%@",regionArraySortM);
    for (NSString *szm in bingArrayM) {
        NSMutableArray *szmArray=[NSMutableArray array];
        for (ZKBingModel *regionModel in  self.bingDataSource) {
            if ([szm isEqualToString:regionModel.szm]) {
                [szmArray addObject:regionModel];
                [self.searchDataSourceChuLi addObject:regionModel.diseaseName];
                [self.bingDictChuLi setObject:szmArray forKey: szm];
            }
        }

    }

}
/**
 *  初始化科室信息
 */
- (void)setupKeshiData
{
    NSArray *data                              = (NSArray *)[ZKFileReadWriteTool readArray:@"keshi.plist"];
    if (data==nil) {
        [ZKHTTPTool GET:[NSString stringWithFormat:@"%@inter/zidian/keshileibie.do",baseUrl] params:nil success:^(id json) {
            // NSLog(@"---%@",json);
    NSArray *data                              = [[json objectForKey:@"body"] objectForKey:@"data"];
            [ZKFileReadWriteTool writeArray:data fileName:@"keshi.plist"];

            [self chuliKeshi:data];
        } failure:^(NSError *error) {

        }];

    }else{
        [self chuliKeshi:data];
    }
//    ZKKeShi *keshi=[[ZKKeShi alloc]init];
//    keshi.departmentName=@"全部科室";
//    [self.keshiDataSource insertObject:keshi atIndex:0];
}
- (void) chuliKeshi:(NSArray *)data{
    self.keshiDataSource=(NSMutableArray *)[ZKKeShi mj_objectArrayWithKeyValuesArray:data];

    self.keshiDictChuLi=[NSMutableDictionary dictionary];
    NSMutableArray *keshiArrayM=[NSMutableArray array];
    NSString *prePro;
    for (ZKKeShi *keshiModel in  self.keshiDataSource) {
        if (![keshiModel.szm isEqualToString:prePro]) {

    prePro                                     = keshiModel.szm;

            if (keshiModel.szm==nil) {
                continue;
            }
            [keshiArrayM addObject:prePro];
        }
    }

    // NSLog(@"%@",regionArraySortM);
    for (NSString *szm in keshiArrayM) {
        NSMutableArray *szmArray=[NSMutableArray array];
        for (ZKKeShi *keshiModel in  self.keshiDataSource) {
            if ([szm isEqualToString:keshiModel.szm]) {
                [szmArray addObject:keshiModel];
                [self.searchDataSourceChuLi addObject:keshiModel.departmentName];
                [self.keshiDictChuLi setObject:szmArray forKey: szm];
            }
        }

    }
}
- (void)setupPaixuData
{
    [self initKeshiPaizu];
}
/**
 *  初始化科室排序
 */
- (void)initKeshiPaizu
{
    ZKPaiXuModel *zhenFeeling =[ZKPaiXuModel initWithOrder:@"zhenFeeling" andOrderName:@"整体评分"];
    ZKPaiXuModel *zhenUserAmount =[ZKPaiXuModel initWithOrder:@"zhenUserAmount" andOrderName:@"人气优先"];
    ZKPaiXuModel *zhenEnvironment =[ZKPaiXuModel initWithOrder:@"zhenEnvironment" andOrderName:@"环境条件"];
    ZKPaiXuModel *zhenWaitTime =[ZKPaiXuModel initWithOrder:@"zhenWaitTime" andOrderName:@"候诊时间"];
    ZKPaiXuModel *zhenTreatTime =[ZKPaiXuModel initWithOrder:@"zhenTreatTime" andOrderName:@"医生看病时间"];
   // ZKPaiXuModel *zhenRecordWait =[ZKPaiXuModel initWithOrder:@"zhenRecordWait" andOrderName:@"报告等待时间"];
    NSMutableArray *array1                     = [NSMutableArray arrayWithObjects: zhenFeeling, zhenUserAmount, zhenEnvironment, zhenWaitTime, zhenTreatTime,nil];

    ZKPaiXuModel *yuanFeeling =[ZKPaiXuModel initWithOrder:@"yuanFeeling" andOrderName:@"整体评分"];
    ZKPaiXuModel *yuanUserAmount =[ZKPaiXuModel initWithOrder:@"yuanUserAmount" andOrderName:@"人气优先"];
      ZKPaiXuModel *yuanzhu=[ZKPaiXuModel initWithOrder:@"yuanMajorSkill" andOrderName:@"主治治疗"];
    ZKPaiXuModel *yuanMajorSkill =[ZKPaiXuModel initWithOrder:@"yuanNurseService" andOrderName:@"护士服务"];
    ZKPaiXuModel *yuanEnvironment =[ZKPaiXuModel initWithOrder:@"yuanEnvironment" andOrderName:@"病房环境"];
    ZKPaiXuModel *yuanTaste =[ZKPaiXuModel initWithOrder:@"yuanTaste" andOrderName:@"饭菜可口"];

    NSMutableArray *array2                     = [NSMutableArray arrayWithObjects:yuanFeeling,yuanUserAmount,yuanzhu,yuanMajorSkill, yuanEnvironment, yuanTaste,nil];
    [self.PaiXuDataSourceChuLi setObject:array1 forKey:@"menZhen"];
    [self.PaiXuDataSourceChuLi setObject:array2 forKey:@"zhuYuan"];
}
- (void)initZhuYuanPaizu
{
    ZKPaiXuModel *hospitalTotalMark =[ZKPaiXuModel initWithOrder:@"hospitalTotalMark" andOrderName:@"整体评分"];
    ZKPaiXuModel *hospitalNumber =[ZKPaiXuModel initWithOrder:@"hospitalNumber" andOrderName:@"人气优先"];
    ZKPaiXuModel *smartValue =[ZKPaiXuModel initWithOrder:@"smartValue" andOrderName:@"魅力指数"];
  //  ZKPaiXuModel *hospitalSkill =[ZKPaiXuModel initWithOrder:@"hospitalSkill" andOrderName:@"自感效果"];
    ZKPaiXuModel *hospitalRoundAttitude =[ZKPaiXuModel initWithOrder:@"hospitalRoundAttitude" andOrderName:@"医生查房"];
    ZKPaiXuModel *hospitalTeach =[ZKPaiXuModel initWithOrder:@"hospitalTeach" andOrderName:@"治疗指导"];
    NSMutableArray *array1                     = [NSMutableArray arrayWithObjects: hospitalTotalMark, hospitalNumber, smartValue, hospitalRoundAttitude,hospitalTeach,nil];

    ZKPaiXuModel *clinicTotalMark =[ZKPaiXuModel initWithOrder:@"clinicTotalMark" andOrderName:@"整体评分"];
    ZKPaiXuModel *clinicNumber =[ZKPaiXuModel initWithOrder:@"clinicNumber" andOrderName:@"人气优先"];
    //ZKPaiXuModel *clinicsmartValue =[ZKPaiXuModel initWithOrder:@"smartValue" andOrderName:@"zhen魅力指数"];
    ZKPaiXuModel *clinicGreet =[ZKPaiXuModel initWithOrder:@"clinicGreet" andOrderName:@"问诊耐心"];
    ZKPaiXuModel *clinicReport =[ZKPaiXuModel initWithOrder:@"clinicReport" andOrderName:@"报告讲解"];
    ZKPaiXuModel *clinicTeach =[ZKPaiXuModel initWithOrder:@"clinicTeach" andOrderName:@"服药指导"];


    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:clinicTotalMark,clinicNumber,clinicGreet, clinicReport, clinicTeach,nil];
    [self.PaiXuDataSourceChuLi setObject:array2 forKey:@"menZhen"];
    [self.PaiXuDataSourceChuLi setObject:array1 forKey:@"zhuYuan"];

}

- (IBAction)addDoctorOrDeparmentClick:(UIButton *)sender {
    
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    
    if(index==ZKHomeViewYiSheng){
        ZKAddDoctorViewController *vc = [[ZKAddDoctorViewController alloc]init];
        vc.title = @"添加医生";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ZKAddDepartmentViewController *vc = [[ZKAddDepartmentViewController alloc]init];
        vc.title = @"添加科室";
        [self.navigationController pushViewController:vc animated:YES];
    }


}
@end
