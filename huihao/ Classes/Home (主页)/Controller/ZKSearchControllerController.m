//
//  ZKSearchControllerController.m
//  huihao
//
//  Created by 张坤 on 15/9/19.
//  Copyright © 2015年 张坤. All rights reserved.
#import "ZKSearchControllerController.h"
#import "ZKSearchTableViewCell.h"
#import "ZKHomeViewController.h"
#import "ZKFileReadWriteTool.h"
#import "MJExtension.h"
#import "ZKFileReadWriteTool.h"
#import "ZKSearchModel.h"
@interface ZKSearchControllerController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *resultDataSource;
@property (nonatomic,strong) UIButton *clearButton;
@property (nonatomic,strong) UIView *destoryView;
@property (nonatomic,strong) NSString *nextSearchText;

@end
@implementation ZKSearchControllerController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)resultDataSource
{
    if (!_resultDataSource) {
        _resultDataSource=[NSMutableArray array];
    }
    return _resultDataSource;
}
- (UIView *)destoryView
{
    if (!_destoryView) {
        _destoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30.0f)];
        _destoryView.backgroundColor = HuihaoBG;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, self.view.width, 30.0f)];
        label.text = @"历史记录";
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = HuihaoTextColor;
        [_destoryView addSubview:label];
    }
    return _destoryView;
}

- (UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setTitle:@"清除历史纪录" forState:UIControlStateNormal];
        _clearButton.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [_clearButton setTitleColor:HuihaoTextColor forState:UIControlStateNormal];
        _clearButton.frame             = CGRectMake(0, 0, self.view.width, 30);

        [_clearButton setImage:[UIImage imageNamed:@"delete_pic"] forState:UIControlStateNormal];
        [_clearButton setBackgroundColor:HuihaoBG];
        
        [_clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchDown];
    }
    return _clearButton;
}
/**
 *  <#Description#>
 */
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 30;

    //mySearchBar.returnKeyType = UIReturnKeySearch; //设置按键类型
    //mySearchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    

    //初始化UISearchBar;
    self.tableView.delegate = self;
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    //因为光标时白色的
    mySearchBar.tintColor=[UIColor blueColor];
    [mySearchBar becomeFirstResponder];
    mySearchBar.backgroundColor=[UIColor clearColor];
    mySearchBar.delegate = self;

    if (self.selectSugIndex==ZKHomeViewYiSheng)
    {
        [mySearchBar setPlaceholder:@"可输入医生姓名、医院、科室、病种"];
    }else
    {
        [mySearchBar setPlaceholder:@"可输入医院、科室、病种"];
    }

    NSString *nextSerach = [[ZKFileReadWriteTool readArray:@"search.plist"] firstObject];
    if (self.isSerach) {
         mySearchBar.text = @"";
    }else{
         mySearchBar.text = nextSerach;
    }

    self.navigationItem.titleView = mySearchBar;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(cancelAction)];
       // self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(cancelAction)];
    [self searchBar:mySearchBar textDidChange:@""];
    if (self.dataSource.count>0) {
    self.tableView.tableHeaderView  = self.destoryView;
        self.tableView.tableFooterView = self.clearButton;
        
    }else
    {
        self.tableView.tableHeaderView=[[UIView alloc]init];
        self.tableView.tableFooterView=[[UIView alloc]init];
    }
}

//确定按钮的action方法
- (void)quedingAction
{
    
}
- (void)cancelAction
{
    [self Zhixing:mySearchBar.text];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

//处理数据
- (void)Zhixing:(NSString *)searchText
{
    [self.delegate search:self clickTitle:searchText];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([searchText isEqualToString:@""])return;
    
    for (NSString *str in self.dataSource) {
        if ([searchText isEqualToString:str]) {
            [self.dataSource removeObject:searchText];
            [self.dataSource insertObject:searchText atIndex:0];
            [ZKFileReadWriteTool writeArray:self.dataSource fileName:@"search.plist"];
            return;
            break;
        }
    }
    [self.dataSource insertObject:searchText atIndex:0];
    [ZKFileReadWriteTool writeArray:self.dataSource fileName:@"search.plist"];
}
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

//清除历史纪录
- (void)clearAction
{
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要清空历史纪录?"]preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZKFileReadWriteTool removeFile:@"search.plist"];
        [self.dataSource removeAllObjects];
        if (self.dataSource.count==0) {
            self.tableView.tableHeaderView=[[UIView alloc]init];
            self.tableView.tableFooterView=[[UIView alloc]init];
        }
        [self.resultDataSource removeAllObjects];
        [self reloadTable];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [mySearchBar removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"1");
    return self.resultDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZKSearchTableViewCell *cell = [ZKSearchTableViewCell cellWithTableView:tableView];
    
    if (self.resultDataSource != nil && self.resultDataSource.count >0) {
        ZKSearchModel *searchModel = self.resultDataSource[indexPath.row];
        
        if ([searchModel.type isEqualToString:@"历史记录"]){
            cell.orderImage.hidden = NO;
            self.tableView.tableHeaderView  = self.destoryView;
            self.tableView.tableFooterView = self.clearButton;
    
        }else
        {
            cell.orderImage.hidden = YES;
            self.tableView.tableHeaderView=[[UIView alloc]init];
            self.tableView.tableFooterView=[[UIView alloc]init];
        }
        
        if ((self.resultDataSource.count - 1) == indexPath.row) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
        
        cell.orderByStr = searchModel.displayLabel;
        if (self.selectSugIndex == ZKHomeViewKeshi) {
            cell.orderByStr = searchModel.display;
        }

    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    ZKSearchModel *searchModel = self.resultDataSource[indexPath.row];

    [self Zhixing:searchModel.display];
}

#pragma UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self.resultDataSource removeAllObjects];
    [self reloadTable];
    self.nextSearchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"====1%zd",self.resultDataSource.count);
    NSString *trimSearch = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (trimSearch!=nil && trimSearch.length>0) {
        NSString *url = [NSString stringWithFormat:@"%@inter/keshi/autoYiyuan.do",baseUrl];
        if (self.selectSugIndex==ZKHomeViewYiSheng) {
            url = [NSString stringWithFormat:@"%@inter/doctor/autoYisheng.do",baseUrl];
        }

    NSDictionary *params=@{
                           @"q":trimSearch,
                           @"currpage":@1,
                           @"limit":@30
                           };
    [ZKHTTPTool POST:url params:params success:^(id json) {
        NSArray *data=[[json objectForKey:@"body"]objectForKey:@"data"];
        NSLog(@"%@",data);
        [self.resultDataSource addObjectsFromArray:[ZKSearchModel mj_objectArrayWithKeyValuesArray:data]];

        if ([self.nextSearchText isEqualToString:trimSearch]) {
             [self reloadTable];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];}
    else
    {
        self.dataSource=(NSMutableArray *)[ZKFileReadWriteTool readArray:@"search.plist"];
                for (NSString *dict in self.dataSource) {
                    ZKSearchModel *searchModel=[[ZKSearchModel alloc]init];
                    searchModel.displayLabel = dict;
                    searchModel.display = dict;
                    searchModel.type = @"历史记录";
                    [self.resultDataSource addObject:searchModel];
                }
    self.tableView.tableFooterView  = self.clearButton;
        self.tableView.tableHeaderView = self.destoryView;
        [self reloadTable];
        return;
    }
  }

//监听搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    
    [self Zhixing:mySearchBar.text];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [mySearchBar resignFirstResponder];
}

@end
