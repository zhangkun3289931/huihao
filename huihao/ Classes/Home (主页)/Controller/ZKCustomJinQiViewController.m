//
//  ZKCustomJinQiViewController.m
//  huihao
//  Created by Alex on 15/9/28.
//  Copyright © 2015年 张坤. All rights reserved.
//
#import "ZKCustomJinQiViewController.h"
#import "ZKJinqiDetialModel.h"
#import "ZKOrderDetialViewController.h"


@interface ZKCustomJinQiViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *buttonContent;
@property (weak, nonatomic) IBOutlet UITextField *jinqiTextView;
@property (strong, nonatomic)  NSArray *jinqiDetials;
@property (strong, nonatomic)  UIButton *selectionButton;
@property (strong, nonatomic)  ZKJinqiDetialModel *detialModel;
- (IBAction)CustomSend:(UIButton *)sender;
- (IBAction)jinqiAction:(UIButton *)sender;
@end

@implementation ZKCustomJinQiViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化数据
    [self loadJinQiData];
    
    self.jinqiTextView.layer.borderColor = HuihaoRedBG.CGColor;
    self.jinqiTextView.layer.borderWidth = 1.0f;
    self.jinqiTextView.layer.cornerRadius = 5.0f;
    
}
/**
 *  初始化锦旗data
 */
- (void)loadJinQiData
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:@"1" forKey:@"isDIY"];
     [MBProgressHUD showMessage: LoaderString(@"httpLoadText") ];
    NSString *url= [NSString stringWithFormat:@"%@inter/keshi/listJinqi.do",baseUrl];
    [ZKHTTPTool POST:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSArray *data=[[json objectForKey:@"body"] objectForKey:@"data"];
        //1.初始化自定义锦旗
        [self initUI:data];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
/**
 *  初始化自定义锦旗
 *
 *  @param data
 */
- (void)initUI:(NSArray *)data {
    NSArray *jinqiDetials= [ZKJinqiDetialModel mj_objectArrayWithKeyValuesArray:data];
    for (int i=0; i<self.buttonContent.subviews.count; i++) {
        UIButton *button =(UIButton *)self.buttonContent.subviews[i];
        button.tag=i;
        [button setTitle:@"" forState:UIControlStateNormal];
        ZKJinqiDetialModel *model=jinqiDetials[i];
        [button.imageView sd_setImageWithURL:[NSURL URLWithString:model.flagImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [button setImage:image forState:UIControlStateNormal];
        }];
    }
    self.jinqiDetials=jinqiDetials;
}
/**
 *  赠送锦旗
 *
 *  @param sender
 */
- (IBAction)CustomSend:(UIButton *)sender {

    //1.锦旗文字判断
    [self jinqiJudge];
   
}
/**
 *  订单信息界面跳转
 */
- (void)pushVC
{
    ZKOrderDetialViewController *orderDetialVC=[[ZKOrderDetialViewController alloc]init];
    orderDetialVC.title       = @"送锦旗";
    self.detialModel.isDiy    = @"1";
    self.detialModel.des      = self.jinqiTextView.text;
    orderDetialVC.detialModel = self.detialModel;
    orderDetialVC.keshiModel  = self.keshiModel;
    orderDetialVC.doctorModel = self.doctorModel;
    [self.navigationController pushViewController:orderDetialVC animated:YES];
}
/**
 *   锦旗判断
 */
- (void)jinqiJudge
{
    NSString *jinqiContent= self.jinqiTextView.text;
    if (jinqiContent.length==0) {
        [MBProgressHUD showError:@"请输入文字"];
        return;
    }
    
    if (jinqiContent.length%2!=0 || jinqiContent.length<6 || jinqiContent.length>10 ) {
        [MBProgressHUD showError:@"文字的字数不正确"];
         return;
    }
    
    if (self.detialModel==NULL) {
        [MBProgressHUD showError:@"请选择锦旗"];
        return;
    }
    //2.订单信息界面跳转
    [self pushVC];
}
/**
 *  选择锦旗
 *
 *  @param sender
 */
- (IBAction)jinqiAction:(UIButton *)sender {
    self.selectionButton.selected=NO;
    sender.selected=YES;
    self.selectionButton=sender;
    self.detialModel= self.jinqiDetials[sender.tag];
}
/**
 *  关闭键盘
 *
 *  @param touches touches description
 *  @param event
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
