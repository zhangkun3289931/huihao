//
//  ZKSwitchBingController.m
//  huihao
//
//  Created by 张坤 on 15/12/2.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKSwitchBingController.h"
#import "ZKFileReadWriteTool.h"
#import "ZKBingModel.h"
#import "ZKDropMenuCell.h"
#import "ZKRedioButton.h"
#import "NSString+Extension.h"
@interface ZKSwitchBingController ()
@property (strong, nonatomic)  NSMutableDictionary *bingDictChuLi;
@property (nonatomic,strong) NSArray *allSZMKey;
@property (nonatomic,strong) NSArray *allSZMValue;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *selectTags;
@property (nonatomic,strong) UIView *headView;
@end

@implementation ZKSwitchBingController
- (UIView *)headView
{
    if (!_headView) {
        _headView =[[UIView alloc]init];
        _headView.frame = CGRectMake(0, 64, self.view.width, 50);
        _headView.backgroundColor = [UIColor whiteColor];
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:_headView];
        self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
        //self.tableView.tableHeaderView = _headView;
    }
    return _headView;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.headView removeFromSuperview];
}
- (NSMutableArray *)selectTags{
    if (!_selectTags) {
        _selectTags = [NSMutableArray array];
    }
    return _selectTags;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSArray *)allSZMKey
{
    if (!_allSZMKey) {
        _allSZMKey=[NSArray array];
        _allSZMKey=[[self.bingDictChuLi allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
    }
    return _allSZMKey;
}
- (NSArray *)allSZMValue
{
    if (!_allSZMValue) {
        _allSZMValue=[NSArray array];
    }
    return _allSZMValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBingData];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:0 target:self action:@selector(colose)];
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:0 target:self action:@selector(quedingAction)];
}

- (void)quedingAction{
    
    if (self.selectTags.count == 0) {
        [MBProgressHUD showError:@"请选择病种"];
        return;
    }
    
    [self.delagate switchItem:self switchWithItem:self.selectTags];
    
    [self dismissViewControllerAnimated:YES completion:nil];    
}
- (void)colose
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  初始化病种信息
 */
- (void)setupBingData
{

    NSArray *data=(NSArray *)[ZKFileReadWriteTool readArray:@"bing.plist"];
    
    NSMutableArray *bingDataSource=(NSMutableArray *)[ZKBingModel mj_objectArrayWithKeyValuesArray:data];
    
    self.bingDictChuLi=[NSMutableDictionary dictionary];
    NSMutableArray *bingArrayM=[NSMutableArray array];
    NSString *prePro;
    
    for (ZKBingModel *regionModel in  bingDataSource) {
        if (![regionModel.szm isEqualToString:prePro]) {
            
            prePro=regionModel.szm;
            
            if (regionModel.szm==nil) {
                continue;
            }
            [bingArrayM addObject:prePro];
        }
    }
    
    // NSLog(@"%@",regionArraySortM);
    for (NSString *szm in bingArrayM) {
        NSMutableArray *szmArray=[NSMutableArray array];
        for (ZKBingModel *regionModel in  bingDataSource) {
            if ([szm isEqualToString:regionModel.szm]) {
                [szmArray addObject:regionModel];
                
                [self.bingDictChuLi setObject:szmArray forKey: szm];
            }
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma 初始化要显示的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.allSZMKey[section];
    NSArray *dataSource= self.bingDictChuLi[key];
    return dataSource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bingDictChuLi.count;
}

#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKDropMenuCell *cell=[ZKDropMenuCell cellWithTableView:tableView ];
    NSString *key=self.allSZMKey[indexPath.section];
    NSArray *arrayA= self.bingDictChuLi[key];
  
    ZKBingModel *regionModel=arrayA[indexPath.row];
    NSString *cellText=regionModel.diseaseName;
    
    cell.orderName.hidden = YES;
    cell.orderImageType.hidden = YES;
    cell.orderTextType.hidden = YES;
    
    cell.title=cellText;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.allSZMKey[section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *keyName=self.allSZMKey[section];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, self.view.width-40);
    [button setTitle:keyName forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    return button;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%@",indexPath);
    
    if (self.selectTags.count == 2) {
        [MBProgressHUD showError:@"最多只能选择两个标签"];
        return;
    }
    

    NSString *key=self.allSZMKey[indexPath.section];
    NSArray *arrayA= self.bingDictChuLi[key];
    
    ZKBingModel *regionModel=arrayA[indexPath.row];
    NSString *cellText=regionModel.diseaseName;
    
    __block BOOL isRepeat = YES;
    [self.selectTags enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:cellText]) {
            [MBProgressHUD showError:@"不能选择重复的标签"];
            *stop = YES;
            isRepeat =NO;
            return ;
        }
    }];
    
    if (isRepeat) {
            [self.selectTags addObject:cellText];
    }
    
    [self createButton];
}

- (void)createButton{
    NSString *nextStr = @"";
    for (int i=0; i<self.selectTags.count; i++) {
        ZKRedioButton *redioButton = [ZKRedioButton buttonWithType:UIButtonTypeCustom];
   
        CGFloat x =10;
        if (i==1) {
            nextStr = self.selectTags[0];
           CGSize  size = [nextStr sizeWithFont:[UIFont systemFontOfSize:13.0]];
             x = 10 * 2  + size.width + 20;
        }
            
        NSString *tagText = self.selectTags[i];
        CGSize size = [tagText sizeWithFont:[UIFont systemFontOfSize:13.0]];
        
        CGFloat y = 10;
        redioButton.frame = CGRectMake(x, y, size.width+20, size.height+10);
        [redioButton setTitle:tagText forState:UIControlStateNormal];
        redioButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [redioButton setBackgroundColor:[ZKCommonTools customColor]];
        [redioButton addTarget:self action:@selector(closeSelf:) forControlEvents:UIControlEventTouchDown];
        [self.buttons addObject:redioButton];
        [self.headView addSubview:redioButton];
    }
}

- (void)closeSelf:(ZKRedioButton *)btn{
    
    [self.buttons enumerateObjectsUsingBlock:^(ZKRedioButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    
    [self.selectTags removeObject:btn.titleLabel.text];
    
    
    [self createButton];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//右侧的索引行，不用去可以的指定,没必要是意义对应的
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allSZMKey;
}


@end
