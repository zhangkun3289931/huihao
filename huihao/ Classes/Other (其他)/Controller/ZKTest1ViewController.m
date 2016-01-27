//
//  ZKTest1ViewController.m
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKTest1ViewController.h"
#import "ZKtest2ViewController.h"

@interface ZKTest1ViewController ()

@end

@implementation ZKTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ZKtest2ViewController *test2=[[ZKtest2ViewController alloc]init];
    [self.navigationController pushViewController:test2 animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
