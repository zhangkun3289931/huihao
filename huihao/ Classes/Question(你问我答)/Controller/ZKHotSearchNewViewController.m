//
//  ZKHotSearchNewViewController.m
//  huihao
//
//  Created by 张坤 on 16/1/15.
//  Copyright © 2016年 张坤. All rights reserved.
//

#import "ZKHotSearchNewViewController.h"
#import "ZKHTTPTool.h"
#import "ZKSearchHotModel.h"
#import "ZKTopicViewController.h"
#import "ZKFileReadWriteTool.h"
#import "ZKSearchTableViewCell.h"

@interface ZKHotSearchNewViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *resultDataSource;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *claerHeatoryRecordBTN;
- (IBAction)claerHeatoryRecordClick:(UIButton *)sender;


@property (nonatomic,strong) NSString *nextSearchText;

@property (nonatomic, retain) UISearchController *searchController;//
@end

@implementation ZKHotSearchNewViewController
/**
 懒加载搜索框控制器
 */
- (void)initSearchBar{

    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    //  接下来都是定义searchBar的样式
    // _searchController.searchBar.frame = CGRectMake(0, 0, 0, 40);
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.showsCancelButton = YES;
    
    [self.searchController.searchBar becomeFirstResponder];
    [self.searchController.searchBar becomeFirstResponder ];
    //是否要显示遮罩
    self.searchController.dimsBackgroundDuringPresentation = false;
    
    
    [self.searchController.searchBar setBackgroundImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]];
    self.searchController.searchBar.barTintColor = TabBottomTextSelectColor;
    self.searchController.searchBar.tintColor = TabBottomTextSelectColor;
    
}

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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
   self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TabBottomTextSelectColor;
    
    [self initSearchBar];
    
    [self initTableView];
}
- (void)initTableView
{
    
    self.tableView.rowHeight = 30.0f;
    
    //  UISearchController，并且把searchBar置为tableHeaderView
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.dataSource=(NSMutableArray *)[ZKFileReadWriteTool readArray:@"ZKSearchHotPlist"];
    
    if (self.dataSource.count == 0) {
        self.claerHeatoryRecordBTN.hidden = YES;
    }else{
        self.claerHeatoryRecordBTN.hidden = NO;
    }
    

    [self.tableView reloadData];
    
    [_searchController.searchBar becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.searchBar.text.length != 0) {
        
        return  self.resultDataSource.count;
    }else
    {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKSearchTableViewCell *cell = [ZKSearchTableViewCell cellWithTableView:tableView];
    
    ZKSearchHotModel *hotModel;
    if (self.searchController.searchBar.text.length != 0) {
        hotModel = [self.resultDataSource objectAtIndex:indexPath.row];
        cell.orderByStr =  hotModel.display;
         cell.orderImage.hidden = YES;
         self.claerHeatoryRecordBTN.hidden = YES;
    }else
    {
        cell.orderImage.hidden = NO;
         self.claerHeatoryRecordBTN.hidden = NO;
        NSString *display= [self.dataSource objectAtIndex:indexPath.row];
        cell.orderByStr =  display;
    }
    
    return cell;
}

/**
 *  现在不管用户输入还是删除search bar的text，UISearchController都会被通知到并执行上述方法。
 *
 *  @param searchController <#searchController description#>
 */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    self.nextSearchText = searchController.searchBar.text;
    
    NSDictionary *params = @{
                             @"q":searchController.searchBar.text,
                             @"limit":@15,
                             @"currpage":@1
                             };
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/wenzhang/autoBingzhong.do",baseUrl] params:params success:^(id json) {
        [self.resultDataSource removeAllObjects];
        NSArray *data= [[json objectForKey:@"body"]objectForKey:@"data"];
        // [tempResults addObjectsFromArray:];
        NSLog(@"%@",[ZKSearchHotModel mj_objectArrayWithKeyValuesArray:data]);
        [self.resultDataSource addObjectsFromArray:[ZKSearchHotModel mj_objectArrayWithKeyValuesArray:data]];
        
        if ([self.nextSearchText isEqualToString:searchController.searchBar.text]) {
            //[self.mySearchDisplayController.searchResultsTableView reloadData];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)willPresentSearchController:(UISearchController *)searchController
{

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZKSearchHotModel *hotModel;
    if (self.searchController.searchBar.text.length != 0) {
        hotModel = [self.resultDataSource objectAtIndex:indexPath.row];
    }else
    {
        NSString *display = self.dataSource[indexPath.row];
        hotModel =[[ZKSearchHotModel alloc]init];
        hotModel.display = display;
    }
    
    [self saveDataWithSezrchModel:hotModel.display];
    
    self.searchController.searchBar.text =  hotModel.display ;
    
    
    ZKTopicViewController *topicVC=[[ZKTopicViewController alloc]init];
    topicVC.title  = hotModel.display;
    topicVC.hotModel = hotModel;
    [self.navigationController pushViewController:topicVC animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    ZKSearchHotModel *hotModel = [[ZKSearchHotModel alloc]init];
    hotModel.display = searchBar.text;
    
    [self saveDataWithSezrchModel:searchBar.text];
    
    ZKTopicViewController *topicVC=[[ZKTopicViewController alloc]init];
    topicVC.title=hotModel.display;
    topicVC.hotModel=hotModel;
    [self.navigationController pushViewController:topicVC animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//处理数据
- (void)saveDataWithSezrchModel :(NSString *)display
{
 
    if (display.length == 0) {
        return;
    }
    
    for (NSString *displayCompare  in self.dataSource) {
        if ([displayCompare isEqualToString:display]) {
            [self.dataSource removeObject:display];
            
            [self.dataSource insertObject:display atIndex:0];
            
            [ZKFileReadWriteTool writeArray:self.dataSource fileName:@"ZKSearchHotPlist"];
            
            return;
            break;
        }
    }
    [self.dataSource insertObject:display atIndex:0];
    [ZKFileReadWriteTool writeArray:self.dataSource fileName:@"ZKSearchHotPlist"];
}

- (IBAction)claerHeatoryRecordClick:(UIButton *)sender {
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要清空历史纪录?"]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZKFileReadWriteTool removeFile:@"searchHot.plist"];
        [self.dataSource removeAllObjects];
        if (self.dataSource.count==0) {
            self.claerHeatoryRecordBTN.hidden = YES;
        }
        [self.resultDataSource removeAllObjects];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
