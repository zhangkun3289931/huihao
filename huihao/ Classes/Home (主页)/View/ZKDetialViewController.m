//
//  ZKDetialViewController.m
//  huihao
//
//  Created by Alex on 15/9/22.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDetialViewController.h"

@interface ZKDetialViewController ()
@property (nonatomic,strong)  UITextView *detial;
@end
@implementation ZKDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.view.backgroundColor=HuihaoBG;
    UITextView *detial=[[UITextView alloc]initWithFrame:self.view.bounds];
    detial.contentInset=UIEdgeInsetsMake(0, 0, 64, 0);
    detial.text=self.hospitalBrief;
    detial.font=[UIFont systemFontOfSize:13.0f];
    detial.textColor = HuihaoBingTextColor;
    detial.editable=NO;
    [self.view addSubview:detial];
    self.detial=detial;
    
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
