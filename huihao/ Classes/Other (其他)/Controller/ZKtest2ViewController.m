//
//  ZKtest2ViewController.m
//  微博
//
//  Created by 张坤 on 15/8/31.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKtest2ViewController.h"
@interface ZKtest2ViewController ()
- (IBAction)buton1:(id)sender;
- (IBAction)button2:(id)sender;
- (IBAction)button3:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *Zview;

@end

@implementation ZKtest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //通过addChildViewController添加子控制器，只要self在，ZKProfileViewController就不会被销毁
    ZKProfileViewController  *feature=[[ZKProfileViewController alloc]init];
    feature.view.frame=CGRectMake(0, 0, 207, 285);
    [self addChildViewController:feature];
    
   ZKTest1ViewController *test1=[[ZKTest1ViewController alloc]init];
    test1.view.frame=CGRectMake(0, 0, 207, 285);
    [self addChildViewController:test1];

//    ZKMessageViewController *message=[[ZKMessageViewController alloc]init];
//    message.view.frame=CGRectMake(0, 0, 207, 285);
//    [self addChildViewController:message];
    /**
     1. 如果两个控制器的View，那么控制器也一定要是父子控制器，
     2. 如果只是View是父子控件，会导致  父控件的通知(点击事件)传递不到子控制器
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)buton1:(id)sender {
    ZKProfileViewController *profile=self.childViewControllers[0];
    ZKTest1ViewController *test1=self.childViewControllers[1];
// ZKMessageViewController *message=self.childViewControllers[2];
    [self.Zview addSubview:profile.view];//一个控件添加的时同一个view，它只会执行一次。
    [test1.view removeFromSuperview];
   // [message.view removeFromSuperview];
}
- (IBAction)button2:(id)sender {
    ZKProfileViewController *profile=self.childViewControllers[0];
    ZKTest1ViewController *test1=self.childViewControllers[1];
  //  ZKMessageViewController *message=self.childViewControllers[2];
    [self.Zview addSubview:test1.view];//一个控件添加的时同一
    [profile.view removeFromSuperview];
   // [message.view removeFromSuperview];
}
- (IBAction)button3:(id)sender {
    ZKProfileViewController *profile=self.childViewControllers[0];
    ZKTest1ViewController *test1=self.childViewControllers[1];
   // ZKMessageViewController *message=self.childViewControllers[2];

   // [self.Zview addSubview:message.view];//一个控件添加的时同一个view，它只会执行一次。
    [profile.view removeFromSuperview];
    [test1.view removeFromSuperview];
    
    
}
@end
