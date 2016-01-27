//
//  ZKDoctorZhuYuanViewController.m
//  huihao
//
//  Created by Alex on 15/9/24.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKDoctorZhuYuanViewController.h"
#import "ASValueTrackingSlider.h"
#import "ZKTextView.h"
#import "ZKOptionZhengZhuangViewController.h"
#import "ZKSitchBingController.h"
#import "ZKNavViewController.h"
#import "ZKForeButtonView.h"
#import "ZKLoginViewController.h"
//#import "KeyboardToolBar.h"

@interface ZKDoctorZhuYuanViewController ()<ASValueTrackingSliderDataSource,ZKSitchBingControllerTableViewControllerDelegate,ZKOptionZhengZhuangViewControllerDelegate,ZKForeButtonViewrDelegate>

@property (weak, nonatomic) IBOutlet UIButton *optionBingClick;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slidingWenZhen;
@property (strong, nonatomic) IBOutlet UILabel *labelWenZhen;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slidingBaoGao;
@property (strong, nonatomic) IBOutlet UILabel *labelBaoGao;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slidingFuyao;
@property (strong, nonatomic) IBOutlet UILabel *labelFuYao;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slidingZhengTi;
@property (strong, nonatomic) IBOutlet UILabel *labelZhengTi;
@property (strong, nonatomic) IBOutlet ZKForeButtonView *kangfuHouXuView;
@property (weak, nonatomic) IBOutlet ZKTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *optionZhengZhuang;

- (IBAction)optionBingBT:(UIButton *)sender;
- (IBAction)optionZhengZhuangBT:(UIButton *)sender;
- (IBAction)commitBT:(UIButton *)sender;

@property (copy,nonatomic) NSString *diseaseId;
@property (assign,nonatomic) HongbaoType hongbaoTy;
@property (nonatomic, strong) NSMutableArray *textFileArray;
@property (assign,nonatomic) BOOL isKeyBoad;
/** 问候耐心*/
@property (copy,nonatomic) NSString *greetMark;
/** 报告讲解*/
@property (copy,nonatomic) NSString *reportMark;
/** 用药指导*/
@property (copy,nonatomic) NSString *teachMark;
/** 后续服务帮助*/
@property (copy,nonatomic) NSString *hasHelp;
/** 整体评分*/
@property (copy,nonatomic) NSString *totalMark;
/** 症状描述*/
@property (copy,nonatomic) NSString *symptom;
/** 描述内容*/
@property (copy,nonatomic) NSString *des;

@property (assign,nonatomic) ZKCommentState isCommentByStatus;


@end

@implementation ZKDoctorZhuYuanViewController
- (NSMutableArray *)textFileArray
{
    if (!_textFileArray) {
        _textFileArray=[NSMutableArray array];
    }
    return _textFileArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化UI
    [self initUI];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //2. 判断是否还可以评价
    [self loadDataIsComment];
}
- (void)loadDataIsComment
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sesseionId=@"";
    if (userModel!=NULL) sesseionId = userModel.sessionId;

    NSDictionary *params=@{
                           @"sessionId":sesseionId,
                           @"doctorId":self.doctorModel.doctorId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/checkYishengPjzy.do",baseUrl] params:params success:^(id json) {

        self.isCommentByStatus = (ZKCommentState)[[json objectForKey:@"state"] integerValue];
        
        if (self.isCommentByStatus == ZKCommentStateDoctorZY) {
            [MBProgressHUD showError:@"今天评价次数已满，请明天在来！"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)initUI {
    [self initSliding:self.slidingFuyao];
   // [self initSliding:self.slidingHouxu];
    [self initSliding:self.slidingBaoGao];
    [self initSliding:self.slidingWenZhen];
    [self initSliding:self.slidingZhengTi];
    [self initHouXuView];

    [self initTextView];

}
- (void)initTextView
{
    self.contentTextView.font=[UIFont systemFontOfSize:13];
    self.contentTextView.backgroundColor=[UIColor whiteColor];
    self.contentTextView.borderClolor = HuihaoRedBG;
    self.contentTextView.placeHoder=@"请输入您的评价（限120字）";
    self.contentTextView.alwaysBounceVertical = YES;//让textView在任何状态下都可以拖拽
    [self.textFileArray addObject:self.contentTextView];

   //  [KeyboardToolBar registerKeyboardToolBarWithTextView:  self.contentTextView];
}
- (void) initHouXuView
{
    self.kangfuHouXuView.type=@"houxu";
    self.kangfuHouXuView.delegate = self;
    self.kangfuHouXuView.models=@[@"有",@"无"];
}

- (int)getCurrentRespond
{
    for (UITextField *tf in self.textFileArray) {
        if (tf.isFirstResponder) {
            return (int)[self.textFileArray indexOfObject:tf];
        }
    }
    return -1;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)foreButtonView:(ZKForeButtonView *)toolBar clickButton:(UIButton *)button type:(NSString *)type
{
    //NSLog(@"%@-- %@",toolBar,button);
    if ([type isEqualToString:@"houxu"]) {
        self.hasHelp=[NSString stringWithFormat:@"%zd",button.tag];
    }

}
- (void)initSliding:(ASValueTrackingSlider *)sliding
{
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"分"];
    [tempFormatter setNegativeSuffix:@"分"];

    sliding.dataSource = self;
    [sliding setNumberFormatter:tempFormatter];
    sliding.minimumValue = 0.0;
    sliding.maximumValue = 10.0;
    sliding.popUpViewCornerRadius = 10.0;
    [sliding setValue:0.0];

    sliding.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:13.0];
    sliding.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    [sliding setPopUpViewAnimatedColors:@[HuihaoRedBG]
                          withPositions:nil];

}
#pragma mark - ASValueTrackingSliderDataSource

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    //value = roundf(value);
    NSString *s = [NSString stringWithFormat:@"%0.1f分", value];

    
    switch (slider.tag) {
        case 0:
            self.reportMark=[NSString stringWithFormat:@"%0.1f", value];
            self.labelWenZhen.text=[NSString stringWithFormat:@"%0.1f分", value];
            break;
        case 1:
            self.teachMark=[NSString stringWithFormat:@"%0.1f", value];
            self.labelBaoGao.text=[NSString stringWithFormat:@"%0.1f分", value];
            break;
        case 2:
            self.greetMark=[NSString stringWithFormat:@"%0.1f", value];
            self.labelFuYao.text=[NSString stringWithFormat:@"%0.1f分", value];
            break;
        case 3:
            self.totalMark=[NSString stringWithFormat:@"%0.1f", value];
            self.labelZhengTi.text=[NSString stringWithFormat:@"%0.1f分", value];
            break;
        default:
            break;
    }

    return s;
}
- (void)optionZhengZhuangViewController:(ZKOptionZhengZhuangViewController *)switchI switchWithItem:(NSString *)str
{
    [self.optionZhengZhuang setTitle:str forState:UIControlStateNormal];

}
- (void)switchItem:(ZKSitchBingController *)switchI switchWithItem:(ZKBingModel *)bingMoel
{
    [self.optionBingClick setTitle:bingMoel.diseaseName forState:UIControlStateNormal];
    self.diseaseId                            = bingMoel.diseaseId;
}


- (IBAction)optionBingBT:(UIButton *)sender {
    ZKSitchBingController *switchVC=[[ZKSitchBingController alloc]init];
    switchVC.delegate = self;
    switchVC.title=@"选择病种";
    switchVC.doctorModel = self.doctorModel;
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:switchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (IBAction)optionZhengZhuangBT:(UIButton *)sender {
    ZKOptionZhengZhuangViewController *switchVC=[[ZKOptionZhengZhuangViewController alloc]init];
    switchVC.delegate = self;
    switchVC.doctorModel = self.doctorModel;
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:switchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (IBAction)commitBT:(UIButton *)sender {
    if (self.isCommentByStatus == ZKCommentStateDoctorZY) {
        [MBProgressHUD showError:@"今天评价次数已满，请明天在来！"];
        return;
    }
    
    
    
    if (self.diseaseId==nil) {
        [MBProgressHUD showError:@"请选择病种"];
        return;
    }

   // self.greetMark=@"10";
    if ([self.reportMark isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请给医生查房打分"];
        return;
    }
   // self.reportMark=@"10";
    if ([self.teachMark isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请给治疗指导打分"];
        return;
    }
   // self.teachMark=@"10";
    if ([self.greetMark isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请给自感效果打分"];
        return;
    }
    // self.totalMark=@"10";
    if ([self.totalMark isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请给整体评分打分"];
        return;
    }

  //  self.hasHelp=@"10";

    if (self.hasHelp==nil) {
        [MBProgressHUD showError:@"请选择康复后续"];
        return;
    }

    self.hongbaoTy = HongbaoType1;
    self.symptom = self.optionZhengZhuang.titleLabel.text;

    self.des = self.contentTextView.text;

    if (self.des.length==0) {
        [MBProgressHUD showError:@"请补充您的评价"];
        return;
    }else
    {
    self.hongbaoTy = HongbaoType2;
    }
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@",userModel.sessionId);
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    [params setValue:self.doctorModel.doctorId forKey:@"doctorId"];
    [params setValue:self.diseaseId forKey:@"dieaseId"];
    [params setValue:userModel.userId forKey:@"userId"];
    [params setValue:self.greetMark forKey:@"professionalSkill"];
    [params setValue:self.reportMark forKey:@"roundAttitude"];
    [params setValue:self.teachMark forKey:@"treatment"];
    [params setValue:self.totalMark forKey:@"totalMark"];
    [params setValue:self.hasHelp forKey:@"hasHelp"];
    [params setValue:self.totalMark forKey:@"totalMark"];
    if (!(self.symptom==nil || [self.symptom isEqualToString:@"点击选择症状"])) {
        [params setValue:self.symptom forKey:@"symptom"];
    }
    [params setValue:self.des forKey:@"des"];

    [MBProgressHUD showMessage:@"发表中..."];
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/doctor/addEvaluateHospitalDoctor.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        if (![ZKCommonTools JudgeState:json controller:nil]) return ;
        [MBProgressHUD showSuccess:@"评价成功"];
        ZKCommonSuccessController *vc=[[ZKCommonSuccessController alloc]init];
        vc.title=@"评价成功";
        vc.hongbaoTy   = self.hongbaoTy;
        vc.doctorModel = self.doctorModel;
        vc.keshiModel = self.keshiModel;
        vc.isKeshi     = false;
        [self.navigationController pushViewController:vc animated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.isKeyBoad) {
//        [self.view endEditing:YES];
//
//    }
}
@end
