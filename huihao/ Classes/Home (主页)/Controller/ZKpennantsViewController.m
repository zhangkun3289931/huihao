//
//  ZKpennantsViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKpennantsViewController.h"
#import "ZKHTTPTool.h"
#import "ZKConst.h"
#import "MBProgressHUD+MJ.h"
#import "ZKUserTool.h"
#import "ZKTongyuQiangViewController.h"
#import "ZKJinqiDetialModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "ZKJinqiButton.h"
#import "ZKCustomJinQiViewController.h"
#import "ZKOrderDetialViewController.h"
@interface ZKpennantsViewController ()

@property (weak, nonatomic) IBOutlet ZKJinqiButton *jinqi1;
@property (weak, nonatomic) IBOutlet ZKJinqiButton *jinqi2;
@property (weak, nonatomic) IBOutlet ZKJinqiButton *jinqi3;
@property (strong, nonatomic) IBOutlet UILabel *jinqiCount;
@property (weak, nonatomic) IBOutlet UIView *btnContent;

- (IBAction)jinqiClick:(ZKJinqiButton *)sender;

- (IBAction)customJinqi:(UIButton *)sender;
- (IBAction)goJinQiQiang:(UIButton *)sender;

- (IBAction)sendClick:(UIButton *)sender;

@property (strong, nonatomic) ZKJinqiButton *selectionButton;
@property (strong, nonatomic) ZKJinqiDetialModel *model;
@property (strong, nonatomic)  NSArray *jinqiDetials;



@end
@implementation ZKpennantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化锦旗数据
    [self initHttpData];
    //2.初始化科室详情
    [self setupKeShiDetialData];
}


- (void)setupKeShiDetialData
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sessionid = @"";
    if (userModel.sessionId!=NULL) {
        sessionid = userModel.sessionId;
    }

    NSString *departmentId = self.keshiModel.departmentId;
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    
    NSDictionary *params=@{
                           @"sessionId":sessionid,
                           @"departmentId":departmentId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/viewKeshi.do",baseUrl] params:params success:^(id json) {
        NSDictionary *data=[[[json objectForKey:@"body"]objectForKey:@"data"] firstObject];
        self.flagCount=[data objectForKey:@"flagCount"];
        //2. 初始化锦旗数
        self.jinqiCount.text=[NSString stringWithFormat:@"%@面",self.flagCount];

    } failure:^(NSError *error) {

        NSLog(@"%@",error.description);

    }];
}


/**
 *  加载锦旗数据
 */
- (void)initHttpData
{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"isDIY"];
    NSString *url= [NSString stringWithFormat:@"%@inter/keshi/listJinqi.do",baseUrl];
    [ZKHTTPTool POST:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSArray *data=[[json objectForKey:@"body"] objectForKey:@"data"];
        //1. 初始化ui
        [self initUI:data];
        //NSLog(@"%@",data);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //NSLog(@"%@",error);
    }];
}
/**
 *  根据data初始化ui
 *
 *  @param data 数据
 */
- (void)initUI:(NSArray *)data {
   NSArray *jinqiDetials= [ZKJinqiDetialModel mj_objectArrayWithKeyValuesArray:data];
    for (int i=0; i<self.btnContent.subviews.count; i++) {
        ZKJinqiButton *button =(ZKJinqiButton *)self.btnContent.subviews[i];
        button.tag=i;
        ZKJinqiDetialModel *model=jinqiDetials[i];
        [button.imageView sd_setImageWithURL:[NSURL URLWithString:model.flagImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [button setImage:image forState:UIControlStateNormal];
        }];
        
        [button setTitle:[NSString stringWithFormat:@"￥%@",model.flagPrice] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"comment_jinqi_bg"] forState:UIControlStateSelected];
    }
    self.jinqiDetials=jinqiDetials;
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendClick:(UIButton *)sender {
    
    if (self.model==NULL) {
        [MBProgressHUD showError:@"请选择你要赠送的锦旗。"];
        return;
    }
    
    ZKOrderDetialViewController *orderDetialVC=[[ZKOrderDetialViewController alloc]init];
    orderDetialVC.title       = @"送锦旗";
    orderDetialVC.detialModel = self.model;
    orderDetialVC.keshiModel  = self.keshiModel;
    orderDetialVC.doctorModel = self.doctorModel;
    [self.navigationController pushViewController:orderDetialVC animated:YES];
}
- (IBAction)jinqiClick:(ZKJinqiButton *)sender {
    self.selectionButton.selected=NO;
    sender.selected=YES;
    self.selectionButton=sender;
    
    self.model=self.jinqiDetials[sender.tag];
    self.model.isDiy=@"0";
}
- (IBAction)customJinqi:(UIButton *)sender {

        ZKCustomJinQiViewController *jinqi=[[ZKCustomJinQiViewController alloc]init];
        jinqi.title = @"自制锦旗";
        jinqi.keshiModel  = self.keshiModel;
        jinqi.doctorModel = self.doctorModel;
        [self.navigationController pushViewController:jinqi animated:YES];
  
}
- (IBAction)goJinQiQiang:(UIButton *)sender {
    ZKTongyuQiangViewController *jinqiVC=[[ZKTongyuQiangViewController alloc]init];
    ZKNavViewController *nav = [[ZKNavViewController alloc]initWithRootViewController:jinqiVC];
    jinqiVC.title = @"锦旗墙";
    jinqiVC.keshiModel = self.keshiModel;
    jinqiVC.doctorModel = self.doctorModel;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
@end
