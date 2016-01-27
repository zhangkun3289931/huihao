//
//  ZKGetConmmentViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKGetConmmentViewController.h"
#import "ZKMenZhenCommentViewViewController.h"
#import "ZKZhuYuanCommentViewController.h"
#import "ZKGetCommonView.h"
#import "ZKIMageModel.h"
#import "huihao.pch"

@interface ZKGetConmmentViewController ()<ZKZKGetCommonViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,strong) UISegmentedControl *segmentedControl1;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) ZKMenZhenCommentViewViewController *keShiMenzhenVC;
@property (nonatomic,strong) ZKZhuYuanCommentViewController *keshiZhuyuanVC;

@property (nonatomic,strong) ZKDocterMenZhenViewController *docterMenZhen;
@property (nonatomic,strong) ZKDoctorZhuYuanViewController *docterCommon;

@property (nonatomic,strong) ZKGetCommonView *commonView;
@end

@implementation ZKGetConmmentViewController
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView=[[UIView alloc] init];
        _contentView.backgroundColor=[UIColor clearColor];
        _contentView.x=0;
        _contentView.y=0+1+self.commonView.height;
        _contentView.width=self.view.width;
        _contentView.height=self.view.height;
    }
    return _contentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //0.初始化Navx
    [self setupNav];
    
    //1.初始化segment
    //[self setupSegment];
    [self setupButton];
    
    //2.初始化commentView
    [self setupCommentView];
    
}
- (void)setupNav
{
    self.view.backgroundColor=HuihaoBG;
    //左边按钮
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithAction:@selector(backAction) target:self imageName:@"navigationbar_back_highlighted" selectImageName:@"navigationbar_back_highlighted"];
}
-(void)setupButton
{
    ZKGetCommonView *commonView=[[ZKGetCommonView alloc]init];
    commonView.delegate=self;
    //commonView.backgroundColor=[UIColor redColor];
    ZKIMageModel *menzhen=[[ZKIMageModel alloc]init];
    menzhen.imageName=@"门诊患者";
    menzhen.imageNormalName=@"menzhen_off";
    menzhen.imageSelectedName=@"menzhen_on";
    ZKIMageModel *zhuyuan=[[ZKIMageModel alloc]init];
    zhuyuan.imageName=@"住院患者";
    zhuyuan.imageNormalName=@"zhuyuan_off";
    zhuyuan.imageSelectedName=@"zhuyuan_on";
    
    commonView.models=@[menzhen,zhuyuan];
    commonView.frame=CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 50);
    [self.view addSubview:commonView];
    self.commonView=commonView;
}
- (void)foreButtonView:(ZKGetCommonView *)toolBar clickButton:(UIButton *)button type:(NSString *)type
{
    NSInteger index=button.tag;
    [self change:index];
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -action
- (void)backAction
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"注意" message:[NSString stringWithFormat:@"您刚刚填写的信息将不再保存？"]preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *qaction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:qaction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupCommentView
{
    [self.view addSubview:self.contentView];
    
    if (self.isKeshi){
        ZKMenZhenCommentViewViewController *menzhenVC=[[ZKMenZhenCommentViewViewController alloc]init];
        [self addChildViewController:menzhenVC];
        menzhenVC.keshiModel = self.keshiModel;
        menzhenVC.doctorModel = self.doctorModel;
        self.keShiMenzhenVC=menzhenVC;
        self.keShiMenzhenVC.view.frame=self.view.bounds;
        [self.contentView addSubview:self.keShiMenzhenVC.view];
        
        ZKZhuYuanCommentViewController *zhuyuanVC=[[ZKZhuYuanCommentViewController alloc]init];
        zhuyuanVC.keshiModel=self.keshiModel;
        zhuyuanVC.doctorModel = self.doctorModel;
        [self addChildViewController:zhuyuanVC];
        self.keshiZhuyuanVC=zhuyuanVC;
        

    } else {
        ZKDoctorZhuYuanViewController *docterCommon=[[ZKDoctorZhuYuanViewController alloc]init];
        [self addChildViewController:docterCommon];
        self.docterCommon=docterCommon;
        
        docterCommon.doctorModel=self.doctorModel;
        docterCommon.keshiModel = self.keshiModel;
        
        self.docterCommon.view.frame=self.view.bounds;
        [self.contentView addSubview:self.docterCommon.view];
        
        ZKDocterMenZhenViewController *docterMenZhen=[[ZKDocterMenZhenViewController alloc]init];
        [self addChildViewController:docterMenZhen];
        docterMenZhen.doctorModel=self.doctorModel;
        docterMenZhen.keshiModel = self.keshiModel;
        self.docterMenZhen=docterMenZhen;

        [self.contentView addSubview:self.docterMenZhen.view];
    }
    NSLog(@"%@---%@",self.keshiModel, self.doctorModel);
    
    [self change:self.segmentedControl1.selected];

}
- (void)setKeshiModel:(ZKKeShiModel *)keshiModel
{
    _keshiModel=keshiModel;
    //[self change:self.segmentedControl1];
}
-(void)change:(NSInteger)currentIndex{
   // [MBProgressHUD showSuccess:@"切换成功"];
    if (self.isKeshi) {
        if (currentIndex != 0) {
            
            [UIView transitionFromView:self.keShiMenzhenVC.view toView:self.keshiZhuyuanVC.view duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
            
           // [self.contentView addSubview:self.keshiZhuyuanVC.view];
           // [self.keshiZhuyuanVC.view removeFromSuperview];
        }else
        {
             [UIView transitionFromView:self.keshiZhuyuanVC.view toView:self.keShiMenzhenVC.view duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
           // [self.contentView addSubview:self.keshiZhuyuanVC.view];
           // [self.keShiMenzhenVC.view removeFromSuperview];
        }
        

        

    }else
    {
        if (currentIndex==0) {
            
            [UIView transitionFromView:self.docterCommon.view toView:self.docterMenZhen.view duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
            
            //            [self.contentView addSubview:self.docterMenZhen.view];
            //            [self.docterCommon.view removeFromSuperview];
        }else
        {
            [UIView transitionFromView:self.docterMenZhen.view toView:self.docterCommon.view duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
            //            [self.contentView addSubview:self.docterCommon.view];
            //            [self.docterMenZhen.view removeFromSuperview];
        }
        
}
    
}

@end
