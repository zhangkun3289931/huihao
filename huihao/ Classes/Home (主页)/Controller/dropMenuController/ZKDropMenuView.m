//
//  ZKDropMenuView.m
//  huihao
//
//  Created by 张坤 on 15/12/15.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDropMenuView.h"
#import "HWTitleButton.h"
#import "ZKDropMenuController.h"
#import "HWDropdownMenu.h"
@interface ZKDropMenuView()<HWDropdownMenuDelegate,dropMenuDelegate>
@property (nonatomic,strong) NSMutableArray *buttons;
//@property (nonatomic,strong) NSMutableArray *menuFilters;
@property (nonatomic, assign) NSInteger isFirst;
@end
static NSMutableArray *_menuFilters;
static CGFloat const marginW = 1;
#define buttonW ((self.width-5*marginW)/self.displayTitles.count)
@implementation ZKDropMenuView
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (NSMutableArray *)menuFilters
{
    if (!_menuFilters) {
        _menuFilters = [NSMutableArray array];
        _menuFilters[ZKDropDataTypeRegion]=@"";
        _menuFilters[ZKDropDataTypeKeshi]=@"";
        _menuFilters[ZKDropDataTypeBingZhong]=@"";
        _menuFilters[ZKDropDataTypePaiXu]=@"";
    }
    return _menuFilters;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"shouye_shaixuan_center_selected_bg"]];
        
        [ZKNotificationCenter  addObserver:self selector:@selector(keshiResult:) name:ZKHomeKeshiResutTypeNotification object:nil];
        
        [ZKNotificationCenter  addObserver:self selector:@selector(clearFilter) name:ZKHomeSegSwitchNotification object:nil];
    }
    return self;
}

- (void)keshiResult:(NSNotification *)noti{
   int resultType = [[noti.userInfo objectForKey:@"resultType"] intValue];

    if(resultType == 0){
        self.displayTitles[ZKDropDataTypeKeshi]=@"科室";
        self.menuFilters[ZKDropDataTypeKeshi]=@"";
    } else if(resultType==1){
        self.displayTitles[ZKDropDataTypeBingZhong]=@"病种";
        self.menuFilters[ZKDropDataTypeBingZhong]=@"";
    }
    //1. 刷新layoutSubview
    [self setNeedsLayout];

}

- (void)setDisplayTitles:(NSMutableArray *)displayTitles
{
    _displayTitles = displayTitles;
    NSInteger count = displayTitles.count;
    for (int i=0; i<count; i++) {
        HWTitleButton *titleButton = [HWTitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:_displayTitles[i] forState:UIControlStateNormal];
        // 监听标题点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.tag=i;
        [self addSubview:titleButton];
        [self.buttons addObject:titleButton];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.buttons.count;
    for (int i=0; i<count; i++) {
        HWTitleButton *titleButton = self.buttons[i];
        titleButton.frame=CGRectMake((buttonW)*i+(marginW*(i+marginW)), 0,buttonW, self.height);
        [titleButton setTitle:_displayTitles[i] forState:UIControlStateNormal];

    }
    
}
- (void)titleClick:(UIButton *)titleButton
{
    NSLog(@"%zd",titleButton.tag);
    // 1.创建下拉菜单
    HWDropdownMenu *menu = [HWDropdownMenu menu];
    menu.delegate = self;
    
    // 2.设置内容
    ZKDropMenuController *vc = [[ZKDropMenuController alloc] init];
    vc.buttonType=titleButton.tag;
    vc.delegate=self;
    vc.view.height =360;
    vc.view.width = self.width;
    
    switch (titleButton.tag) {
        case ZKDropDataTypeRegion:
            vc.dataSourceDict=self.regionDictChuLi;
            break;
        case ZKDropDataTypeKeshi:
            vc.dataSourceDict=self.keshiDictChuLi;
            break;
        case ZKDropDataTypeBingZhong:
            vc.dataSourceDict=self.bingDictChuLi;
            break;
        case ZKDropDataTypePaiXu:
            vc.dataSourceDict=self.PaiXuDataSourceChuLi;
            break;
        default:
            
            break;
    }

    menu.contentController = vc;
    // 3.显示
    [menu showFrom:titleButton];
}

#pragma mark - ZKRegionControllerDelegate

- (void)dropMenuController:(ZKDropMenuController *)region selectionButton:(NSIndexPath *)indexPath buttonType:(NSUInteger)type
{    
    if (type == ZKDropDataTypeRegion) {
        self.isFirst=2;
        NSArray *arrayA=[self getDiceKey:self.regionDictChuLi withIndexPath:indexPath];
        ZKRegionModel *regionModel=arrayA[indexPath.row];
        self.menuFilters[ZKDropDataTypeRegion]=regionModel.areaId;
        self.displayTitles[ZKDropDataTypeRegion]=[self appendTeplaceStr:regionModel.areaName];
    }
    else if(type == ZKDropDataTypeKeshi){
         self.isFirst=1;
        NSArray *arrayA=[self getDiceKey:self.keshiDictChuLi withIndexPath:indexPath];
        ZKKeShi *regionModel=arrayA[indexPath.row];
        self.menuFilters[ZKDropDataTypeKeshi]=regionModel.departmentId;
        self.displayTitles[ZKDropDataTypeKeshi]=[self appendTeplaceStr:regionModel.departmentName];
        
    } else if(type==ZKDropDataTypeBingZhong){
        self.isFirst=0;
        
        NSArray *arrayA=[self getDiceKey:self.bingDictChuLi withIndexPath:indexPath];
        ZKBingModel *regionModel=arrayA[indexPath.row];
        self.menuFilters[ZKDropDataTypeBingZhong]=regionModel.diseaseId;
        self.displayTitles[ZKDropDataTypeBingZhong]=[self appendTeplaceStr:regionModel.diseaseName];
     
    }else if (type==ZKDropDataTypePaiXu)
    {
        self.isFirst=2;
        
        NSArray *szmKey;
        szmKey= [self.PaiXuDataSourceChuLi.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        NSString *key=szmKey[indexPath.section];

        
        NSArray *arrayA = self.PaiXuDataSourceChuLi[key];
        ZKPaiXuModel *paixuModel = arrayA[indexPath.row];
        self.menuFilters[ZKDropDataTypePaiXu]= paixuModel.order;
        if ([key isEqualToString:@"menZhen"]) {
            self.displayTitles[ZKDropDataTypePaiXu] = [self appendTeplaceStr:[NSString stringWithFormat:@"门:%@",paixuModel.orderName]];
        }else if([key isEqualToString:@"zhuYuan"])
        {
             self.displayTitles[ZKDropDataTypePaiXu] = [self appendTeplaceStr:[NSString stringWithFormat:@"院:%@",paixuModel.orderName]];
        }
    
    }
    
    //1. 刷新layoutSubview
    [self setNeedsLayout];
    [self.delegate dropdownMenuViewWithItem:self andTitleArray:self.menuFilters andFirst:self.isFirst];
}

- (NSString *)appendTeplaceStr :(NSString *)str{
    if (str.length <= 4) {
        return str;
    }else{
         return [[str substringToIndex:4] stringByAppendingString:@"..."];
    }
}

- (NSArray *) getDiceKey:(NSMutableDictionary *)mulDict withIndexPath:(NSIndexPath *)indexPath
{
    NSArray *szmKey;
    szmKey= [mulDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString *key=szmKey[indexPath.section];
    return  mulDict[key];
}

- (void)dropMenuController:(ZKDropMenuController *)region buttonType:(NSUInteger)type
{
    if (type == ZKDropDataTypeRegion) {
        self.displayTitles[ZKDropDataTypeRegion]=@"全国";
        self.menuFilters[ZKDropDataTypeRegion]=@"";
    }
    else if(type == ZKDropDataTypeKeshi){
        self.displayTitles[ZKDropDataTypeKeshi]=@"科室";
        self.menuFilters[ZKDropDataTypeKeshi]=@"";
    } else if(type==ZKDropDataTypeBingZhong){
        self.displayTitles[ZKDropDataTypeBingZhong]=@"病种";
        self.menuFilters[ZKDropDataTypeBingZhong]=@"";
    }else if (type==ZKDropDataTypePaiXu)
    {
        self.displayTitles[ZKDropDataTypePaiXu]=@"智能排序";
        self.menuFilters[ZKDropDataTypePaiXu]= @"";
    }
    
    [self setNeedsLayout];
    
    [self.delegate dropdownMenuViewWithItem:self andTitleArray:self.menuFilters andFirst:2];

}
- (void)clearFilter{
    
    self.displayTitles[ZKDropDataTypeRegion]=@"全国";
    self.menuFilters[ZKDropDataTypeRegion]=@"";
    self.displayTitles[ZKDropDataTypeKeshi]=@"科室";
    self.menuFilters[ZKDropDataTypeKeshi]=@"";
    self.displayTitles[ZKDropDataTypeBingZhong]=@"病种";
    self.menuFilters[ZKDropDataTypeBingZhong]=@"";
    self.displayTitles[ZKDropDataTypePaiXu]=@"智能排序";
    self.menuFilters[ZKDropDataTypePaiXu]= @"";
    
    [self setNeedsLayout];
    
    [self.delegate dropdownMenuViewWithItem:self andTitleArray:self.menuFilters andFirst:2];

    
}
#pragma mark - HWDropdownMenuDelegate
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(HWDropdownMenu *)menu clickButton:(UIButton *)button
{
    // 让箭头向下
    button.selected=NO;
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(HWDropdownMenu *)menu clickButton:(UIButton *)button
{
    // 让箭头向上
    button.selected = YES;
}

@end
