//
//  ZKRegionControllerTableViewController.m
//  huihao
//
//  Created by 张坤 on 15/10/2.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDropMenuController.h"
#import "huihao.pch"
#import "ZKHomeViewController.h"
#import "ZKDropMenuCell.h"
@interface ZKDropMenuController()
@property (nonatomic,strong) NSMutableArray *pinyinS;
@property (nonatomic,strong) NSArray *allSZMKey;
@property (nonatomic,strong) NSArray *allSZMValue;
@end

@implementation ZKDropMenuController
- (NSArray *)allSZMKey
{
    if (!_allSZMKey) {
        _allSZMKey=[NSArray array];
        _allSZMKey=[[self.dataSourceDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
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
   
    self.tableView.backgroundColor=[UIColor whiteColor];
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置右侧索引行文字的颜色
    self.tableView.sectionIndexColor=TabBottomTextSelectColor;
    //设置由奢索引背景的颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundColor = [UIColor whiteColor];

    
    [self settupTableHeader];
    
    
}
- (void) settupTableHeader{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, self.view.width, 30);
    switch (self.buttonType) {
        case ZKDropDataTypeRegion:
            [button setTitle:@"不限地区" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, self.view.width-70);
            break;
        case ZKDropDataTypeKeshi:
            [button setTitle:@"不限科室" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, self.view.width-70);
            break;
        case ZKDropDataTypeBingZhong:
            [button setTitle:@"不限病种" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, self.view.width-70);
            break;
        case ZKDropDataTypePaiXu:
            [button setTitle:@"智能排序" forState:UIControlStateNormal];
            [button setBackgroundColor:ZKColor(238, 238, 238)];
            button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, self.view.width-135);
            break;
        default:
            break;
    }
    [button setTitleColor:HuihaoRedBG forState:UIControlStateNormal];
  
    button.titleLabel.font=[UIFont systemFontOfSize:12.0f];
 
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    self.tableView.tableHeaderView=button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma 初始化要显示的行数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.allSZMKey[section];
    NSArray *dataSource= self.dataSourceDict[key];
    return dataSource.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceDict.count;
}


#pragma mark 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKDropMenuCell *cell=[ZKDropMenuCell cellWithTableView:tableView ];
    NSString *key=self.allSZMKey[indexPath.section];
    NSArray *arrayA= self.dataSourceDict[key];
    NSString *cellText;
        switch (self.buttonType) {
            case ZKDropDataTypeRegion:
            {
                ZKRegionModel *regionModel=arrayA[indexPath.row];
                 cellText=regionModel.areaName;
            }
                break;
            case ZKDropDataTypeKeshi:
            {
                ZKKeShi *regionModel=arrayA[indexPath.row];
                cellText=regionModel.departmentName;
            }
                break;
            case ZKDropDataTypeBingZhong:
            {
                ZKBingModel *regionModel=arrayA[indexPath.row];
                cellText=regionModel.diseaseName;
            }
                break;
            case ZKDropDataTypePaiXu:
            {
                ZKPaiXuModel *paixuModel=arrayA[indexPath.row];
                cellText=paixuModel.orderName;
            }
                break;
            default:
            {
               
            }
                break;
        }
    
    cell.title = cellText;
    
    if (self.buttonType != ZKDropDataTypePaiXu) {
        cell.orderName.hidden = YES;
        cell.orderImageType.hidden = YES;
        cell.orderTextType.hidden = YES;
        cell.menuItemName.hidden = NO;
        cell.menuItemName.text = cellText;
    }else{
        cell.orderName.hidden = NO;
        cell.orderImageType.hidden = NO;
        cell.orderTextType.hidden = NO;
        cell.menuItemName.hidden = YES;
        cell.orderName.text = cellText;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.orderTextType.hidden = NO;
                cell.orderImageType.hidden = NO;
                
                cell.orderTextType.text = @"门诊";
                cell.orderImageType.image = [UIImage imageNamed:@"menzhen_on"];
            }else
            {
                cell.orderTextType.hidden = YES;
                cell.orderImageType.hidden = YES;
            }
            
        }else
        {
            if (indexPath.row == 0) {
                cell.orderTextType.hidden = NO;
                cell.orderImageType.hidden = NO;
                
                cell.orderTextType.text = @"住院";
                cell.orderImageType.image = [UIImage imageNamed:@"zhuyuan_on"];
            }else
            {
                cell.orderTextType.hidden = YES;
                cell.orderImageType.hidden = YES;
            }
           
        }
        
        
   }
        
    
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
    
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];

    button.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, self.view.width-40);
    
    [button setTitle:keyName forState:UIControlStateNormal];
    
    if(self.buttonType==ZKDropDataTypePaiXu) {
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    
    [button setBackgroundColor:ZKColor(238, 238, 238)];
    return button;
}
- (void)btnClick:(UIButton *)btn
{
    [ZKNotificationCenter postNotificationName:@"zkButtonClickNotifacation" object:nil];
    [self.delegate dropMenuController:self buttonType:self.buttonType];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [ZKNotificationCenter postNotificationName:@"zkButtonClickNotifacation" object:nil];
    [self.delegate dropMenuController:self selectionButton:indexPath buttonType:self.buttonType];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.buttonType==ZKDropDataTypePaiXu) {
        if (section == 0) {
            return 0;
        }else
        {
            return 10;
        }
    }else
    {
        return 30;
    }
   
}

//右侧的索引行，不用去可以的指定,没必要是意义对应的
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.buttonType==ZKDropDataTypePaiXu)
    {
        return nil;
    }else
    {
        return self.allSZMKey;
    }
}



@end
