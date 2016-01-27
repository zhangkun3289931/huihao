//
//  ZKRegionControllerTableViewController.h
//  huihao
//
//  Created by 张坤 on 15/10/2.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKPaiXuModel.h"
#import "ZKRegionModel.h"
#import "ZKBingModel.h"
#import "ZKKeShi.h"

@class ZKDropMenuController;
@protocol dropMenuDelegate <NSObject>

- (void)dropMenuController:(ZKDropMenuController*) region selectionButton:(NSIndexPath *)indexPath buttonType:(NSUInteger) type;

- (void)dropMenuController:(ZKDropMenuController*) region buttonType:(NSUInteger) type;
@end

@interface ZKDropMenuController : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableDictionary *dataSourceDict;
@property (nonatomic,assign) NSInteger buttonType;
@property (nonatomic,weak) id<dropMenuDelegate> delegate;
@end
