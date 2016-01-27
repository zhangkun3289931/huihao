//
//  ZKOptionZhengZhuangViewController.m
//  huihao
//
//  Created by 张坤 on 15/11/26.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKOptionZhengZhuangViewController.h"
#import "BoSectionBackgroundLayout.h"
#import "ZKZhengZhuangModel.h"
#import "MBProgressHUD+MJ.h"
#import "HWStatusToolbar.h"
#import "ZKClearLabel.h"
#import "ZKUserTool.h"
#import "ZKHTTPTool.h"
#import "TagModel.h"
#import "TagCell.h"

#define kMarginTop 134

@interface ZKOptionZhengZhuangViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,HWStatusToolbarDelegate>
{
    NSMutableDictionary *_newDict;
    NSMutableArray *_newArrays;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) NSMutableArray   *originDataList;
@property (nonatomic,strong ) UIScrollView     *scrollerView;
@property (nonatomic,strong ) UITableView      *tableView;
@property (nonatomic,strong ) NSArray          *titles;
@property (nonatomic,strong ) NSArray          *contents;
@property (nonatomic, strong) NSMutableString  *mstr;
@end

static const NSInteger zkScrollerW = 80;
static const NSInteger zkCollectionH = 100;

@implementation ZKOptionZhengZhuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNav];
    
    [self initData];
}
/**
 *  请求数据
 */
- (void)initData
{
    
    ZKUserModdel *userModel=[ZKUserTool user];
    
    NSString * departmentId = self.keshiModel.departmentId;
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    NSDictionary *params=@{
                           @"departmentId":departmentId,
                           @"sessionId":userModel.sessionId
                           };
    
    [MBProgressHUD showMessage:LoaderString(@"httpLoadText")];
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/zidian/zhengzhuang.do",baseUrl] params:params success:^(id json) {
        
        NSArray *data=[ZKZhengZhuangModel mj_objectArrayWithKeyValuesArray:[[json objectForKey:@"body"] objectForKey:@"data"]];
        
      
        [self ChuLiData:data];
        
        //初始化UI界面
        [self initUI];
        [self reloadTable];
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:@"请检查你的网络" toView:self.view];
    }];
}
- (void)initUI {
    
    self.title = @"请选择症状";
    //初始化UI
    UIScrollView *scrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,80, self.view.height)];
    scrollerView.userInteractionEnabled = YES;
    scrollerView.contentSize = CGSizeMake(0, zkScrollerW *(self.titles.count+1));
    scrollerView.backgroundColor = [UIColor whiteColor];
    self.scrollerView = scrollerView;
    [self.view addSubview:scrollerView];
    
    HWStatusToolbar *btView = [HWStatusToolbar toolbar];
    btView.dalegate = self;
    btView.models = self.titles;
    [self.scrollerView addSubview:btView];
    
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(zkScrollerW, 0,self.view.width - zkScrollerW, self.view.height)];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
/**
 *  处理返回来的Json数据
 *
 *  @param titlesM_p
 *  @param newDict_p
 *  @param data
 */
- (void)ChuLiData:(NSArray *)data
{
    NSMutableArray *titlesM = [NSMutableArray array];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];

    for (int i = 0; i<data.count; i++) {
        ZKZhengZhuangModel *model=data[i];
        NSMutableArray *contentsM=[NSMutableArray array];
        NSString *symptomHeadId= model.symptomId;
        for (int ai = 11; ai<data.count; ai++) {
            ZKZhengZhuangModel *modelZ=data[ai];
            NSString *symptomSuperId= modelZ.symptomSuperId;
            if ([symptomHeadId isEqualToString:symptomSuperId]) {
                [contentsM addObject:modelZ.symptomName];
            }
        }
        [newDict setObject:contentsM forKey:model.symptomName];
        [titlesM addObject:model];
    }
    
    _newDict = newDict;
    self.titles = titlesM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return   self.contents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_botton_hui"]];
        cell.textLabel.height = 30;
        cell.textLabel.width = self.view.width;
        cell.textLabel.textColor=[UIColor colorWithWhite:0.160 alpha:1.000];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text =self.contents[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger count= self.originDataList.count+1;
  
    if (count>5) {
        // NSLog(@"最多只能选择4个");
        [MBProgressHUD showError:@"最多只能选择5个"];
        return;
    }
    
    NSString *newItem= self.contents[indexPath.row];
    for (TagModel *item in self.originDataList) {
        if ([item.text isEqualToString:newItem]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"已经选择%@了",newItem]];
            return;
        }
    }
    
    if (count==0) {
        self.scrollerView.y = 0;
        self.scrollerView.height = self.view.height;
        self.tableView.y = 0;
        self.tableView.height = self.view.height;
    }else
    {
        self.scrollerView.y = zkCollectionH + 2;
        self.scrollerView.height = self.view.height - zkCollectionH;
        self.tableView.y = zkCollectionH + 2;
        self.tableView.height = self.view.height - zkCollectionH;
    }
    
    TagModel *model= [[TagModel alloc]init];
    model.text = newItem;
    [self.originDataList addObject:model];
    [self.collection reloadData];
    
    
}
- (void)toolBar:(HWStatusToolbar *)toolBar clickButton:(UIButton *)button
{
    ZKZhengZhuangModel *model=  toolBar.models[button.tag];
    self.contents=_newDict[model.symptomName];
    [self reloadTable];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
/**
 *  初始化导航栏
 */
- (void)initNav
{
   // self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:0 target:self action:@selector(queDing)];
    
    self.tableView.rowHeight = 30.0;
    
    [self.mstr appendString:@"sds"];
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.collection registerNib:[UINib nibWithNibName:@"TagCell" bundle:nil]  forCellWithReuseIdentifier:@"tagCell"];
    [self.collection setCollectionViewLayout:[[BoSectionBackgroundLayout alloc]init] animated:YES];
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)queDing
{
    if (self.originDataList.count==0) {
        [MBProgressHUD showError:@"请选择症状"];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableString *itemStr =[NSMutableString stringWithString:@""];
    for (TagModel *obj in  self.originDataList) {
        [itemStr appendFormat:@"%@,",obj.text];
    }
    [self.delegate optionZhengZhuangViewController:self switchWithItem:[itemStr substringToIndex:itemStr.length-1] ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.originDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagCell" forIndexPath:indexPath];
    
    TagModel *model=self.originDataList[indexPath.row];
    [cell setTitleStr:model.text color:model.color];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    TagModel *model = self.originDataList[indexPath.row];
    size = [self calculateCellSize:model.text];
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.originDataList removeObjectAtIndex:indexPath.row];
    
    [self.collection deleteItemsAtIndexPaths:@[indexPath]];
}


#pragma mark - utils


//通过text获取tag
-(TagModel *) getObjectInList:(NSString *)str{
    for (TagModel *model in self.originDataList) {
        if ([model.text isEqualToString:str]) {
            return model;
        }
    }
    return nil;
}

//计算cell size
-(CGSize)calculateCellSize:(NSString *)content{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByCharWrapping];
    size.height = 20;
    size.width = floorf(size.width + 15);
    return size;
}


#pragma mark - getter/setter

-(NSMutableArray *)originDataList{
    if (_originDataList == nil) {
        _originDataList = [[NSMutableArray alloc] init];
    }
    return _originDataList;
}


//

@end
