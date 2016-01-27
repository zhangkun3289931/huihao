//
//  ZKNewFeatureController.m
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKNewFeatureController.h"
#import "ZKTest1ViewController.h"
#import "ZKTabBarController.h"
#import "ZKHTTPTool.h"
#import "ZKConst.h"

@interface ZKNewFeatureController() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIPageControl *pageController;
@property (nonatomic, strong) ZKTest1ViewController *test1;
@property (nonatomic, assign) NSInteger kNewFeatureCount;
@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic)  UIButton *clearBTN;
@end
@implementation ZKNewFeatureController
/**
 *  使用collectionView实现
 *
 *  @return <#return value description#>
 */
- (UIButton *)clearBTN
{
    if (!_clearBTN) {
        _clearBTN=[UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBTN setTitle:@"跳过" forState:UIControlStateNormal];
        [_clearBTN setBackgroundColor:[UIColor clearColor]];
        [_clearBTN setTitleColor:ShenLVColor forState:UIControlStateNormal];
        _clearBTN.titleLabel.font=[UIFont systemFontOfSize:14];
        [_clearBTN addTarget:self action:@selector(startButon) forControlEvents:UIControlEventTouchUpInside];
        _clearBTN.frame=CGRectMake(self.view.width-50, 20, 45,20);
    }
    return _clearBTN;
}
- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
        CGFloat newFW= _scrollerView.size.width;
        [_scrollerView setBounces:NO];
        [_scrollerView setPagingEnabled:YES];
        //设置scrollerView的容量
        [_scrollerView setContentSize:CGSizeMake(newFW*self.kNewFeatureCount, 0)];
        _scrollerView.delegate=self;
        [_scrollerView setShowsVerticalScrollIndicator:NO];
        [_scrollerView setShowsHorizontalScrollIndicator:NO];
        //添加图片到scrollerView中
        for (int i=0; i<self.kNewFeatureCount; i++) {
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.contentMode= UIViewContentModeScaleAspectFit;
            imageView.size=_scrollerView.size;
            imageView.y=0;
            imageView.x=i*newFW;
            NSDictionary *dictImage=self.data[i];
            //UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:]];
            NSLog(@"%@",[dictImage objectForKey:@"imgUrl"]);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dictImage objectForKey:@"imgUrl"]]];
            [_scrollerView addSubview:imageView];
            //如果是最后imageView 添加按钮
            if (i==self.kNewFeatureCount-1) {
                [self setupLastImageView:imageView];
            }
        }
    }
    return _scrollerView;
}
- (UIPageControl *)pageController
{
    if (!_pageController) {
        _pageController=[[UIPageControl alloc]init];
        _pageController.numberOfPages=self.kNewFeatureCount;
        _pageController.centerX=_scrollerView.size.width*0.5;
        _pageController.y=_scrollerView.size.height-30;
        _pageController.currentPage=0;
        //UIPageConttroller, 就算不设置宽高，里边的内容也会显示出来
        [_pageController setUserInteractionEnabled:NO];
        [_pageController setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageController setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
        
    }
    return _pageController;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadHttpData];
}
- (void)loadHttpData
{
    NSDictionary *params=@{
                           @"imgType":@"2"
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@/inter/guanggao/guanggao.do",baseUrl] params:params success:^(id json) {
     
        //NSLog(@"%@",json);
        self.data=  [[json objectForKey:@"body"] objectForKey:@"data"];
        self.kNewFeatureCount=self.data.count;
        [self.view addSubview:self.scrollerView];
        [self.view addSubview:self.pageController];
        [self.view addSubview:self.clearBTN];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        
    }];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //四舍五入计算出页码
    int currentNo= scrollView.contentOffset.x/scrollView.size.width+0.5;
    self.pageController.currentPage=currentNo;
}
- (void)setupLastImageView:(UIImageView *)lastImageView
{
    //1 .开启交互功能
    lastImageView.userInteractionEnabled=YES;
    //2 .开始微博
    UIButton *startButton=[UIButton buttonWithType: UIButtonTypeCustom];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startButton.width=self.view.width;
    startButton.height=self.view.height;
    startButton.x=0;
    startButton.y=0;
    [startButton setTitle:@"" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startButon) forControlEvents:UIControlEventTouchUpInside];
    [lastImageView addSubview:startButton];
}
- (void)shareClick:(UIButton *)button
{
    button.selected=!button.isSelected;
}
- (void)startButon
{
    ZKTabBarController *tabBar=[[ZKTabBarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController=tabBar;
}
- (void)dealloc
{
    //NSLog(@"delloc");
}
@end
