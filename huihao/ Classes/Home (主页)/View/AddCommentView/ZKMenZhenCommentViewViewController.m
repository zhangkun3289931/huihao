//
//  ZKMenZhenCommentViewViewController.m
//  huihao
//
//  Created by Alex on 15/9/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKMenZhenCommentViewViewController.h"
#import "ZKSitchBingController.h"
#import "ZKNavViewController.h"
#import "ZYQAssetPickerController.h"
#import "ZKTextView.h"
#import "ZKForeButtonView.h"
#import "ZKHTTPTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKUserTool.h"
#import "ZKCommonSuccessController.h"
#import "ASValueTrackingSlider.h"
#import "ZKClearImageView.h"
#import "ZKLoginViewController.h"
#import "ZKOptionZhengZhuangViewController.h"
//#import "KeyboardToolBar.h"

@interface ZKMenZhenCommentViewViewController ()<UIScrollViewDelegate,ZYQAssetPickerControllerDelegate,ZKSitchBingControllerTableViewControllerDelegate,ZKForeButtonViewrDelegate,ASValueTrackingSliderDataSource,ZKClearImageViewDelagate,UITextFieldDelegate,ZKOptionZhengZhuangViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (assign, nonatomic) BOOL isShowOptionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *OptionViewHeight;
@property (strong, nonatomic) IBOutlet UIView *OpotionView;
@property (weak, nonatomic) IBOutlet UIButton *switchBingBt;
@property (weak, nonatomic) IBOutlet UIButton *guanHaoTujing;
@property (weak, nonatomic) IBOutlet UIButton *HuangJIngTiaoJian;
@property (weak, nonatomic) IBOutlet UITextField *houzhenTime;
@property (weak, nonatomic) IBOutlet UITextField *kanBingTime;
@property (weak, nonatomic) IBOutlet UIButton *dengDaiTime;
@property (weak, nonatomic) IBOutlet UIButton *menZhenLiucheng;
@property (weak, nonatomic) IBOutlet UIButton *zhengTiGanShou;
@property (weak, nonatomic) IBOutlet UITextField *MenZhenFeiYong;
@property (weak, nonatomic) IBOutlet UITextField *MenZhenJianChaFeiyong;
@property (weak, nonatomic) IBOutlet UIButton *switchBingBT;
@property (strong, nonatomic) IBOutlet UIView *imageDisplayView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic)  UILabel *zhenTiScore;
@property (strong, nonatomic)  UILabel *HuangJIngTiaoJianScore;
@property (strong, nonatomic)  UILabel *guanHaoTujingScore;
@property (strong,nonatomic) NSMutableArray *photoImages;
@property (strong, nonatomic)ZKTextView *textView;
@property (copy,nonatomic) NSString *diseaseId;
/** 挂号途径*/
@property (copy,nonatomic) NSString *guaWay;
/** 环境条件*/
@property (copy,nonatomic) NSString *envirement;
/** 候诊时间*/
@property (copy,nonatomic) NSString *waitTime;
/** 医生诊疗时间 */
@property (copy,nonatomic) NSString *treatTime;
/** 报告等待时间 */
@property (copy,nonatomic) NSString *recordWait;
/** 门诊流程 */
@property (copy,nonatomic) NSString *zhenFlow;
/** 整体感受*/
@property (copy,nonatomic) NSString *zhenFeeling;
//选填
/** 门诊药品费用*/
@property (copy,nonatomic) NSString *zhenDrugCost;
/** 门诊检查费用*/
@property (copy,nonatomic) NSString *zhenCheckCost;
/** 症状描述*/
@property (copy,nonatomic) NSString *symptomDescription;
/** 描述120字*/
@property (copy,nonatomic) NSString *zhenDescription;
/** 红包类型*/
@property (assign,nonatomic) HongbaoType hongbaoTy;
@property (strong, nonatomic)  UIButton *addImageBTN;

@property (assign,nonatomic) ZKCommentState isCommentByStatus;

- (IBAction)OptionAction:(UIButton *)sender;
- (IBAction)switchBing:(UIButton *)sender;
- (IBAction)switchZhengZhuang:(UIButton *)sender;
- (IBAction)switchImageAction:(UIButton *)sender;
- (IBAction)commitBT:(UIButton *)sender;
@end
#define imageMargin  2
#define imageW  ((self.imageDisplayView.width-imageMargin*3)*0.25)
@implementation ZKMenZhenCommentViewViewController
- (UIButton *)addImageBTN
{
    if (!_addImageBTN) {
        _addImageBTN=[UIButton buttonWithType:UIButtonTypeCustom];
        //[_addImageBTN setTitle:@"+" forState:UIControlStateNormal];
        [_addImageBTN setImage:[UIImage imageNamed:@"common_addImage"] forState:UIControlStateNormal];
        [_addImageBTN setBackgroundColor:QianLVColor];
        [_addImageBTN setTitleColor:ShenLVColor forState:UIControlStateNormal];
        [_addImageBTN addTarget:self action:@selector(switchImageAction:) forControlEvents:UIControlEventTouchUpInside];
        _addImageBTN.frame = CGRectMake(imageMargin, 0, imageW,imageW+6);
    }
    return _addImageBTN;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    //2.初始化ui
    [self initUI];
    
    [self loadDataIsComment];

}
- (void)loadDataIsComment
{
   NSString *departmentId = self.keshiModel.departmentId;
    
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sesseionId=@"";
    if (userModel!=NULL) sesseionId  = userModel.sessionId;
    
    NSDictionary *params=@{
                           @"sessionId":sesseionId,
                           @"departmentId":departmentId
                           };
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/checkKeshiPjmz.do",baseUrl] params:params success:^(id json) {
        
        self.isCommentByStatus = (ZKCommentState)[[json objectForKey:@"state"] integerValue];
        
        if (self.isCommentByStatus == ZKCommentStateDepartmentMZ) {
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

//初始化ui
- (void)initUI
{
    // 0.添加选择图片的按钮
    [self.imageDisplayView addSubview:self.addImageBTN];
    // 0.1 修改文本框placeholder的文字颜色
    [self.houzhenTime setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.kanBingTime setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.MenZhenFeiYong setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.MenZhenJianChaFeiyong setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];


    //1. 初始化挂号途径
    ZKForeButtonView *tuJingView = [ZKForeButtonView toolbar];
    tuJingView.x = tuJingView.y = 0;
    tuJingView.width = self.guanHaoTujing.width;
    tuJingView.height = self.guanHaoTujing.height;
    tuJingView.delegate = self;
    tuJingView.models = @[@"大厅",@"网上",@"朋友",@"其他"];
    tuJingView.type = @"tujing";
    [self.guanHaoTujing addSubview:tuJingView];

    //2. 初始化评分
    ASValueTrackingSlider *starRatingView1 = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 3, self.guanHaoTujing.width-50, 25)];
    starRatingView1.dataSource = self;
    UILabel *score1 = [self scoreWithlabel];
    starRatingView1.tag = 0;
    [self.HuangJIngTiaoJian addSubview:starRatingView1];
    [self.HuangJIngTiaoJian addSubview:score1];
    self.HuangJIngTiaoJianScore = score1;
    [self initSliding:starRatingView1];

    //3. 初始评论
    ZKTextView *textView=[[ZKTextView alloc]initWithFrame:self.contentView.bounds];
    textView.font=[UIFont systemFontOfSize:13];
    textView.placeHoder=@"请输入您的评价（限120字）";
    textView.borderClolor = HuihaoRedBG;
    textView.alwaysBounceVertical = NO;//让textView在任何状态下都可以拖拽
    //想让文字跟着一起懂， 可以使用uilabel
    [self.contentView addSubview:textView];
    self.textView = textView;
    // [KeyboardToolBar registerKeyboardToolBarWithTextView:self.textView];

    //4. 初始化门诊按钮
    ZKForeButtonView *dengdaiView = [ZKForeButtonView toolbar];
    dengdaiView.x = tuJingView.y=0;
    dengdaiView.width = self.menZhenLiucheng.width;
    dengdaiView.height = self.menZhenLiucheng.height;
    dengdaiView.delegate = self;
    dengdaiView.type = @"dengdai";
    dengdaiView.models = @[@"15分钟+",@"30分钟+",@"1小时+",@"1天+"];
    [self.dengDaiTime addSubview:dengdaiView];



    //5. 初始化门诊按钮
    ZKForeButtonView *menZhenView = [ZKForeButtonView toolbar];
    menZhenView.x = tuJingView.y=0;
    menZhenView.width = self.menZhenLiucheng.width;
    menZhenView.height = self.menZhenLiucheng.height;
    menZhenView.delegate = self;
    menZhenView.type = @"menzhen";
    menZhenView.models = @[@"很好",@"好",@"一般",@"很差"];
    [self.menZhenLiucheng addSubview:menZhenView];

    // 6. 整体评分
    ASValueTrackingSlider *starRatingView2 = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 3, self.zhengTiGanShou.width-50, 25) ];
    starRatingView2.dataSource = self;
    UILabel *score2 = [self scoreWithlabel];
    starRatingView2.tag = 1;
    [self.zhengTiGanShou addSubview:starRatingView2];
    [self.zhengTiGanShou addSubview:score2];
    self.zhenTiScore = score2;
    [self initSliding:starRatingView2];

    //6.添加action
    [self addAction];
    
    
    self.OptionViewHeight.constant = 0;
    [self.OpotionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [self.OpotionView layoutIfNeeded];

}
/**
 *  添加action
 */
- (void)addAction
{
    //1.使用addTarget监听文本框数值的改变
    [self.houzhenTime addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    [self.dengDaiTime addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
    [self.kanBingTime addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventAllEditingEvents];
}
#define mark -action
/**
 *  action
 *
 *  @param tf <#tf description#>
 */
- (void)valueChange:(UITextField *)tf
{
    if (tf.text.length>3) {
        //[MBProgressHUD showError:@"最多只能输入1000分钟"];
        tf.text=@"1000";
    }
}
/**
 *  textFile的valuechange代理方法
 *
 *  @param textField <#textField description#>
 *  @param range     <#range description#>
 *  @param string    <#string description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  return YES;
}
/**
 *  初始化label
 *
 *  @return <#return value description#>
 */
- (UILabel *)scoreWithlabel
{
    UILabel *score=[[UILabel alloc]initWithFrame:CGRectMake(self.guanHaoTujing.width-50, 0, 50, 30)];
    score.textColor = HuihaoRedBG;
    score.text=@"0.0分";
    score.font=[UIFont systemFontOfSize:13.0];
    score.textAlignment = NSTextAlignmentRight;
    return score;
}
/**
 *  初始化sliding
 *
 *  @param sliding sliding description
 */
- (void)initSliding:(ASValueTrackingSlider *)sliding
{
    sliding.dataSource   = self;
    sliding.minimumValue = 0.0;
    sliding.maximumValue = 10.0;
    [sliding setValue:0.0];
    sliding.font         = [UIFont systemFontOfSize:13];
    sliding.textColor    = [UIColor colorWithWhite:1 alpha:0.8];
    [sliding setPopUpViewAnimatedColors:@[HuihaoRedBG]
                         withPositions:nil];

}
#pragma mark - 打分控件的代理
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    //value = roundf(value);
    NSString *s = [NSString stringWithFormat:@"%0.1f分", value];

    switch (slider.tag) {
        case 0:
            self.HuangJIngTiaoJianScore.text = [NSString stringWithFormat:@"%0.1f分 ",value ];
            self.envirement                  = [NSString stringWithFormat:@"%0.1f",value ];
            break;
        case 1:
            self.zhenTiScore.text=[NSString stringWithFormat:@"%0.1f分 ",value ];
            self.zhenFeeling = [NSString stringWithFormat:@"%0.1f",value ];
            break;
        default:
            break;
    }
    return s;
}
#pragma mark -按钮view的代理
- (void)foreButtonView:(ZKForeButtonView *)toolBar clickButton:(UIButton *)button type:(NSString *)type
{
    if ([type isEqualToString:@"tujing"]) {
        self.guaWay=[NSString stringWithFormat:@"%zd",(button.tag+1)];
    } else if([type isEqualToString:@"menzhen"])
    {
        self.zhenFlow=[NSString stringWithFormat:@"%zd",(button.tag+1)];
    } else if ([type isEqualToString:@"dengdai"])
    {
        self.recordWait=[NSString stringWithFormat:@"%zd",(button.tag+1)];
    }
}
#pragma mark 选择症状的代理
- (void)optionZhengZhuangViewController:(ZKOptionZhengZhuangViewController *)switchI switchWithItem:(NSString *)str
{
   [self.switchBingBT setTitle:str forState:UIControlStateNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/**
 *  选择病种的action
 *
 *  @param sender
 */
- (IBAction)switchBing:(UIButton *)sender {
    ZKSitchBingController *switchVC=[[ZKSitchBingController alloc]init];
    switchVC.delegate    = self;
    switchVC.keshiModel  = self.keshiModel;
    switchVC.doctorModel = self.doctorModel;
    switchVC.title=@"选择病种";
    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:switchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
/**
 *  选择症状的action
 *
 *  @param sender
 */
- (IBAction)switchZhengZhuang:(UIButton *)sender {
    ZKOptionZhengZhuangViewController *switchVC=[[ZKOptionZhengZhuangViewController alloc]init];
    switchVC.delegate    = self;
    switchVC.keshiModel  = self.keshiModel;
    switchVC.doctorModel = self.doctorModel;

    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:switchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)switchImageAction:(UIButton *)sender {

    NSLog(@"ddd");

    ZYQAssetPickerController *picker       = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection =(4- self.photoImages.count);
    picker.assetsFilter                    = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups                 = NO;
    picker.delegate                        = self;
    picker.selectionFilter                 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
    NSTimeInterval duration                = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];

    [self presentViewController:picker animated:YES completion:NULL];
}
/**
 *  选择图片的action
 *
 *  @param sender
 */
- (void)switchImage:(UIButton *)sender {

}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

    //判断photoImages是否超过4张
    if ((self.photoImages.count+assets.count)>4) {
        [MBProgressHUD showError:@"最多只能选择4张照片"];
        return;
    }
    //每次选择照片子后，都将self.imageContent.subviews清空
    [self.imageDisplayView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) {
             [obj removeFromSuperview];
        }
    }];
    //循环添加image到self.photoImages;
    for (int i                             = 0; i<assets.count; i++) {
    ALAsset *asset                         = assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.photoImages addObject:tempImg];
    }

    //根据self.photoImages;计算imageview的个数以及位置
    [self ReloadImages];
}

- (void)ReloadImages
{
    for (int i                             = 0; i<self.photoImages.count; i++) {
        ZKClearImageView *imgview=[[ZKClearImageView alloc] initWithFrame:CGRectMake((imageW+imageMargin)*i, 0, imageW,imageW)];
        imgview.delegate = self;
        imgview.tag = i;
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = YES;
        [imgview setImage:self.photoImages[i]];
        [self.imageDisplayView addSubview:imgview];
    }
    self.addImageBTN.frame                 = CGRectMake((imageW+imageMargin)*self.photoImages.count, 0, imageW,imageW);
    if (self.photoImages.count==4) {
        [self.addImageBTN removeFromSuperview];
    }else
    {
        [self.imageDisplayView addSubview:self.addImageBTN];

    }
}
/**
 *  提交评论
 *
 *  @param sender
 */
- (IBAction)commitBT:(UIButton *)sender {
    if (self.isCommentByStatus == ZKCommentStateDepartmentMZ) {
        [MBProgressHUD showError:@"今天评价次数已满，请明天在来！"];
        return;
    }
    
    
    
    //1.判断必填
    [self judgeBi];
}
/**
 *  必填判断
 */
- (void)judgeBi
{
    if (self.diseaseId==nil) {
        [MBProgressHUD showError:@"请选择病种"];
        return;
    }
    /** 挂号途径*/
    if (self.guaWay==nil) {
        [MBProgressHUD showError:@"请选择挂号途径"];
        return;
    }
    /** 环境条件*/
    if ([self.envirement isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请选择环境条件"];
        return;
    }
    /**  候诊时间*/
    self.waitTime                          = self.houzhenTime.text;
    if ([self.waitTime isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入候诊时间"];

        return;
    }
    /**  医生诊疗时间*/
    self.treatTime                         = self.kanBingTime.text;
    if ([self.treatTime isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入医生看病时间"];
        //[self.kanBingTime becomeFirstResponder];
        return;
    }
    /**   报告等待时间 */
    if (self.recordWait==nil) {
        [MBProgressHUD showError:@"请选择报告等待时间"];
        return;
    }
    /**  门诊流程*/
    if (self.zhenFlow==nil) {
        [MBProgressHUD showError:@"请选择门诊流程"];
        return;
    }
    /**  整体感受*/
    if ([self.zhenFeeling isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请输入整体评分"];
        return;
    }
    self.hongbaoTy = HongbaoType1;
    //2.判断选填
    [self judgeXuan];
    //3. 请求网络
    [self loadHTTP];
}
- (void)judgeXuan
{
    /** 门诊药品费用*/
    self.zhenDrugCost = self.MenZhenFeiYong.text;

    /** 门诊检查费用*/
    self.zhenCheckCost = self.MenZhenJianChaFeiyong.text;

    /** 症状描述*/
    self.symptomDescription = self.switchBingBT.titleLabel.text;
    if (self.symptomDescription!=nil &&self.zhenDrugCost!=nil && self.zhenCheckCost!=nil) {
    self.hongbaoTy = HongbaoType2;
    }
    /** 描述120字*/
    self.zhenDescription = self.textView.text;
    if (self.zhenDescription!=nil) {
    self.hongbaoTy = HongbaoType3;
    }

}
//访问手机号请求
- (void)loadHTTP
{
    // NSLog(@"%@",userModel.sessionId);
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [MBProgressHUD showMessage:@"发表中..."];
    NSLog(@"%@",[self loadParams] );
    [manager POST:[NSString stringWithFormat:@"%@inter/keshi/addPjmz.do",baseUrl] parameters:[self loadParams] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";

    for (int i = 0; i<self.photoImages.count; i++) {
            self.hongbaoTy = HongbaoType4;
            // 设置时间格式
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *name=[NSString stringWithFormat:@"%@%d", str, i+1];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSLog(@"%@",fileName);
            //循环的时候每个data 给不同的 fileName就可以在一个post请求里发送多个图片了
            // 拼接文件数据
            NSData *data = UIImageJPEGRepresentation(self.photoImages[i], 1.0);
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        if ([ZKCommonTools JudgeState:responseObject controller:nil]) {
            [MBProgressHUD showMessage:@"提交成功"];
            // NSLog(@"%@",responseObject);

            ZKCommonSuccessController *vc=[[ZKCommonSuccessController alloc]init];
            vc.title=@"评价成功";
            vc.keshiModel  = self.keshiModel;
            vc.doctorModel = self.doctorModel;
            vc.hongbaoTy   = self.hongbaoTy;
            vc.isKeshi = true;
            [MBProgressHUD hideHUD];
            [self.navigationController pushViewController:vc animated:YES];
            [super dismissViewControllerAnimated:YES completion:nil];

        };
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
/**
 *  加载参数
 *
 *  @return <#return value description#>
 */
- (NSMutableDictionary *)loadParams
{
    ZKUserModdel *userModel=[ZKUserTool user];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    
    NSString *departmentId = self.keshiModel.departmentId;
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    
    [params setValue:departmentId forKey:@"departmentId"];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    [params setValue:self.diseaseId forKey:@"diseaseId"];
    [params setValue:userModel.userId forKey:@"userId"];
    [params setValue:self.guaWay forKey:@"guaWay"];
    [params setValue:self.envirement forKey:@"envirement"];
    [params setValue:self.waitTime forKey:@"waitTime"];
    [params setValue:self.treatTime forKey:@"treatTime"];
    [params setValue:self.zhenFlow forKey:@"zhenFlow"];
    [params setValue:self.recordWait forKey:@"recordWait"];
    [params setValue:self.zhenFeeling forKey:@"zhenFeeling"];
    if (![self.zhenDrugCost isEqualToString:@""]) {
        [params setValue:self.zhenDrugCost forKey:@"zhenDrugCost"];
    }
    if (![self.zhenCheckCost isEqualToString:@""]) {
        [params setValue:self.zhenCheckCost forKey:@"zhenCheckCost"];
    }
    if (!([self.symptomDescription isEqualToString:@"点击选择症状"] || [self.symptomDescription isEqualToString:@""])) {
        [params setValue:self.symptomDescription forKey:@"symptomDescription"];
    }
    if (![self.zhenDescription isEqualToString:@""] ) {
        [params setValue:self.zhenDescription forKey:@"zhenDescription"];
    }
    return params;
}
- (void)switchItem:(ZKSitchBingController *)switchI switchWithItem:(ZKBingModel *)bingMoel
{
    [self.switchBingBt setTitle:bingMoel.diseaseName forState:UIControlStateNormal];
    self.diseaseId                         = bingMoel.diseaseId;
}
#pragma mark -关闭图片的代理
- (void)clearImageView:(ZKClearImageView *)clearImageView
{
    [self.photoImages removeObject:clearImageView.image];
    [self.imageDisplayView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self ReloadImages];
}
/**
 *  textField 限制
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return
 */
-(BOOL)textField:(UITextField *)textField {
    NSUInteger proposedNewLength           = textField.text.length;
    if (proposedNewLength > 3) return NO;//限制长度
    return YES;
}
#pragma mark -getter
-(NSMutableArray *)photoImages
{
    if (!_photoImages) {
        _photoImages=[NSMutableArray array];
    }
    return _photoImages;
}

- (IBAction)OptionAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if (self.isShowOptionView) {
    self.OptionViewHeight.constant = 0;
        [self.OpotionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }else
    {
    self.OptionViewHeight.constant = 285;
        [self.OpotionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
    }
    
    [self.OpotionView layoutIfNeeded];
    self.isShowOptionView = !self.isShowOptionView;


}
@end
