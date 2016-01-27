//
//  ZKDropMenuView.h
//  huihao
//
//  Created by 张坤 on 15/12/15.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKDropMenuView;
@protocol ZKDropdownMenuViewDelegate <NSObject>
- (void)dropdownMenuViewWithItem:(ZKDropMenuView *)dropMenuView andTitleArray:(NSArray *)titles andFirst:(NSInteger)isFirst;

@end

@interface ZKDropMenuView : UIView
/** menu的数据源*/
@property (nonatomic,strong) NSMutableArray *displayTitles;
/** 地区的数据源*/
@property (nonatomic,strong) NSMutableDictionary *regionDictChuLi;
/** 科室的数据源*/
@property (nonatomic,strong) NSMutableDictionary *keshiDictChuLi;
/** 病种的数据源*/
@property (nonatomic,strong) NSMutableDictionary *bingDictChuLi;
/** 排序的数据源*/
@property (nonatomic,strong) NSMutableDictionary *PaiXuDataSourceChuLi;

@property (nonatomic,weak) id<ZKDropdownMenuViewDelegate> delegate;

@end
