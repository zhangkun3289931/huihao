//
//  ZKCollectionViewController.m
//  huihao
//
//  Created by 张坤 on 15/12/8.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKCollectionViewController.h"
#import "MJRefresh.h"
#import "ZKTopicModel.h"
#import "ZKTopicTableViewCell.h"
#import "ZKMeSpeakViewController.h"

@interface ZKCollectionViewController ()

@end

@implementation ZKCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setupParams:(NSMutableDictionary *)params
{
    
}
- (NSString *)setupUrl
{
    if (!self.isTopic) {
         return [NSString stringWithFormat:@"%@inter/wenzhang/listMyCollection.do",baseUrl];
    }else
    {
         return [NSString stringWithFormat:@"%@inter/wenzhang/listMyTopic.do",baseUrl];
    }
}

@end
