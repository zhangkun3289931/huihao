//
//  ZKSearchControllerController.h
//  huihao
//
//  Created by 张坤 on 15/9/19.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKSearchControllerController;
@protocol HWSearchControllerDelegate <NSObject>
typedef enum{
    ZKHomeViewKeshi = 0,
    ZKHomeViewYiSheng

} ZKHomeViewType;

- (void)search:(ZKSearchControllerController *)search clickTitle:(NSString *)title;
@end
@interface ZKSearchControllerController : UITableViewController <UISearchDisplayDelegate,UISearchBarDelegate>

{
    UISearchBar *mySearchBar;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger selectSugIndex;
@property (nonatomic,assign) BOOL isSerach;
@property (nonatomic,weak) id<HWSearchControllerDelegate> delegate;
@end
