//
//  ZKZhuYuanCommentViewController.m
//  huihao
//
//  Created by Alex on 15/9/21.
//  Copyright © 2015年 张坤. All rights reserved.


#import "ZKZhuYuanCommentViewController.h"
#import "ZKMenZhenCommentViewViewController.h"
#import "ZKSitchBingController.h"
#import "ZKOptionZhengZhuangViewController.h"
#import "ZKNavViewController.h"
#import "ZYQAssetPickerController.h"
#import "ZKTextView.h"
#import "ZKForeButtonView.h"
#import "ZKHTTPTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZKUserTool.h"
#import "ASValueTrackingSlider.h"
#import "ZKClearImageView.h"
#import "ZKLoginViewController.h"
@interface ZKZhuYuanCommentViewController ()<UIScrollViewDelegate,ZYQAssetPickerControllerDelegate,ZKSitchBingControllerTableViewControllerDelegate,ZKForeButtonViewrDelegate,ZKOptionZhengZhuangViewControllerDelegate,ASValueTrackingSliderDataSource,ZKClearImageViewDelagate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeight;
- (IBAction)optionButtonAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *optionChildView;
@property (assign, nonatomic) BOOL isShowOptionView;



- (IBAction)ZYSwitchBingAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchBingBT;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchDay;
@property (strong, nonatomic) UILabel *ZYSwitchDayScore;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchZhuZhi;
@property (strong, nonatomic) UILabel *ZYSwitchZhuZhiScore;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchHushi;
@property (strong, nonatomic) UILabel *ZYSwitchHuShiScore;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchHuanjing;
@property (strong, nonatomic) UILabel *ZYSwitchHuanJingScore;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchFancai;
@property (strong, nonatomic) UILabel *ZYSwitchFancaiScore;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchGanShou;
@property (strong, nonatomic) UILabel *ZYSwitchGanShouScore;
@property (weak, nonatomic) IBOutlet UITextField *ZYSwitchJianChaFree;
@property (weak, nonatomic) IBOutlet UIButton *ZYSwitchZhengZhuang;
- (IBAction)ZYSwitchZhengZhuangAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *ZYSwitchContentView;
@property (weak, nonatomic) IBOutlet UIView *ZYSwitchPhotoView;
@property (strong, nonatomic) ZKTextView *textView;
- (IBAction)ZYSwitchImage:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *ziFeiBiLi;
@property (strong, nonatomic) IBOutlet UILabel *ziFeiBiLiLabel;

@property (weak, nonatomic) IBOutlet UIButton *commit;
@property (strong,nonatomic) NSMutableArray *photoImages;
@property (copy,nonatomic) NSString *diseaseId;
- (IBAction)sendCommit:(UIButton *)sender;
/** 主治医师分数*/
@property (copy,nonatomic) NSString *majorSkill;
/** 护士服务分数*/
@property (copy,nonatomic) NSString *nurseService;
/** 病房环境*/
@property (copy,nonatomic) NSString *environment;
/** 康复后续*/
@property (copy,nonatomic) NSString *recovery;
/** 整体感受*/
@property (copy,nonatomic) NSString *yuanFeeling;
/** 住院天数*/
@property (copy,nonatomic) NSString *yuanDay;
/** 饭菜可口*/
@property (copy,nonatomic) NSString *taste;
/** 手术总费用*/
@property (copy,nonatomic) NSString *operationCost;
/** 住院总费用*/
@property (copy,nonatomic) NSString *yuanCost;
/** 住院描述*/
@property (copy,nonatomic) NSString *yuanDescription;
@property (copy,nonatomic) NSString *symptomDescription;
@property (strong, nonatomic)  UIButton *addImageBTN;

@property (assign,nonatomic) ZKCommentState isCommentByStatus;
@end

#define imageMargin  2
#define imageW  ((self.ZYSwitchPhotoView.width-imageMargin*3)*0.25)
@implementation ZKZhuYuanCommentViewController
- (UIButton *)addImageBTN
{
    if (!_addImageBTN) {
        _addImageBTN=[UIButton buttonWithType:UIButtonTypeCustom];
       // [_addImageBTN setTitle:@"+" forState:UIControlStateNormal];
                [_addImageBTN setImage:[UIImage imageNamed:@"common_addImage"] forState:UIControlStateNormal];
        [_addImageBTN setBackgroundColor:QianLVColor];
        [_addImageBTN setTitleColor:ShenLVColor forState:UIControlStateNormal];
        [_addImageBTN addTarget:self action:@selector(ZYSwitchImage:) forControlEvents:UIControlEventTouchUpInside];
    _addImageBTN.frame                = CGRectMake(imageMargin, 0, imageW,imageW+6);
    }
    return _addImageBTN;
}

- (void)loadDataIsComment
{
    NSString *departmentId = self.keshiModel.departmentId;
    
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    
    ZKUserModdel *userModel=[ZKUserTool user];
    NSString *sesseionId=@"";
    if (userModel!=NULL) sesseionId   = userModel.sessionId;
    NSDictionary *params=@{
                           @"sessionId":sesseionId,
                           @"departmentId":departmentId
                           };
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/keshi/checkKeshiPjzy.do",baseUrl] params:params success:^(id json) {
        self.isCommentByStatus = (ZKCommentState)[[json objectForKey:@"state"] integerValue];
        
        if (self.isCommentByStatus == ZKCommentStateDepartmentZY) {
            [MBProgressHUD showError:@"今天评价次数已满，请明天在来！"];
        }
        

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //2. 判断是否还可以评价
    [self loadDataIsComment];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.ZYSwitchPhotoView addSubview:self.addImageBTN];

    [self.ZYSwitchJianChaFree setValue:HuihaoBingTextColor forKeyPath:@"_placeholderLabel.textColor"];




    //[self loadDataIsComment];
   // self.scrollerView.delegate = self;
    //1. 初始化住院评分

    ZKForeButtonView *menZhenView = [ZKForeButtonView toolbar];
    menZhenView.x = menZhenView.y=0;
    menZhenView.width = self.ZYSwitchDay.width;
    menZhenView.height = self.ZYSwitchDay.height;
    menZhenView.delegate = self;
    menZhenView.type=@"zhuyuan";
    menZhenView.models=@[@"1-3",@"4-6",@"7-9",@"10+"];
    [self.ZYSwitchDay addSubview:menZhenView];


    //2. 初始化主治评分
    ASValueTrackingSlider *TQzhuzhi = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 0, self.ZYSwitchZhuZhi.width-50, 30) ];
    TQzhuzhi.dataSource = self;
    UILabel *zhushilb = [self scoreWithlabel];
    TQzhuzhi.tag = 0;
    [self.ZYSwitchZhuZhi addSubview:TQzhuzhi];
    [self.ZYSwitchZhuZhi addSubview:zhushilb];
    self.ZYSwitchZhuZhiScore = zhushilb;
    [self initSliding:TQzhuzhi];

    //3. 初始化护士评分
    ASValueTrackingSlider *TQhushi = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 0, self.ZYSwitchHushi.width-50, 30) ];
    TQhushi.dataSource = self;
    TQhushi.tag = 1;
    UILabel *hushiLB = [self scoreWithlabel];
    [self.ZYSwitchHushi addSubview:TQhushi];
    [self.ZYSwitchHushi addSubview:hushiLB];
    self.ZYSwitchHuShiScore = hushiLB;
     [self initSliding:TQhushi];
    //4. 初始化环境评分
    ASValueTrackingSlider *TQhuanjing = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 0, self.ZYSwitchHushi.width-50, 30) ];
    TQhuanjing.dataSource = self;
    TQhuanjing.tag = 2;
    UILabel *huangjingLB = [self scoreWithlabel];
    [self.ZYSwitchHuanjing addSubview:TQhuanjing];
    [self.ZYSwitchHuanjing addSubview:huangjingLB];
    self.ZYSwitchHuanJingScore = huangjingLB;
    [self initSliding:TQhuanjing];

    //5. 初始化饭菜评分
    ASValueTrackingSlider *TQfancai = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 0, self.ZYSwitchHushi.width-50, 30)];
    TQfancai.dataSource = self;
    TQfancai.tag = 3;
    UILabel *fancaiLB = [self scoreWithlabel];
    [self.ZYSwitchFancai addSubview:TQfancai];
    [self.ZYSwitchFancai addSubview:fancaiLB];
    self.ZYSwitchFancaiScore = fancaiLB;
     [self initSliding:TQfancai];

    //6. 初始化整体感受评分
    ASValueTrackingSlider *TQganshou = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0, 0, self.ZYSwitchHushi.width-50, 30) ];
    TQganshou.dataSource = self;
    TQganshou.tag = 4;
    UILabel *ganshouLB = [self scoreWithlabel];
    [self.ZYSwitchGanShou addSubview:TQganshou];
    [self.ZYSwitchGanShou addSubview:ganshouLB];
    self.ZYSwitchGanShouScore = ganshouLB;
       [self initSliding:TQganshou];

    //3. 初始评论
    ZKTextView *textView=[[ZKTextView alloc]initWithFrame:self.ZYSwitchContentView.bounds];
    textView.font=[UIFont systemFontOfSize:13.0f];
    textView.borderClolor=HuihaoRedBG;
    textView.placeHoder=@" 请输入你的评价(限120字)";
    textView.alwaysBounceVertical = NO;//让textView在任何状态下都可以拖拽
    //想让文字跟着一起懂， 可以使用uilabel
    [self.ZYSwitchContentView addSubview:textView];
    self.textView = textView;

    self.ziFeiBiLi.tag = 5;
    [self initSliding:self.ziFeiBiLi];

    
    self.optionViewHeight.constant = 0;
    [self.optionChildView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [self.optionChildView layoutIfNeeded];
}

- (void)initSliding:(ASValueTrackingSlider *)sliding
{
    NSNumberFormatter *tempFormatter  = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"分"];
    [tempFormatter setNegativeSuffix:@"分"];

    sliding.dataSource = self;
    [sliding setNumberFormatter:tempFormatter];
    sliding.minimumValue = 0.0;
    sliding.maximumValue = 10.0;
    [sliding setValue:0.0];
    sliding.popUpViewCornerRadius = 10.0;

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
    
   
    
    if (slider.tag==5) {
        s = [NSString stringWithFormat:@"%zd%%", (NSInteger)value*10];
        //  NSString *scoreStr= [NSString stringWithFormat:@"%0.1f分",value];
        NSString *scoreIn = [NSString stringWithFormat:@"%zd",(NSInteger)value*10];
        self.ziFeiBiLiLabel.text = s;
        self.operationCost = scoreIn;
    }
    NSString *scoreStr = [NSString stringWithFormat:@"%0.1f分",value];
    NSString *scoreIn  = [NSString stringWithFormat:@"%0.1f",value];
    switch (slider.tag) {
        case 0:
            self.ZYSwitchZhuZhiScore.text = scoreStr;
            self.majorSkill = scoreIn;
            break;
        case 1:
            self.ZYSwitchHuShiScore.text = scoreStr;
            self.nurseService = scoreIn;
            break;
        case 2:
            self.ZYSwitchHuanJingScore.text = scoreStr;
            self.environment = scoreIn;
            break;
        case 3:
            self.ZYSwitchFancaiScore.text = scoreStr;
            self.taste = scoreIn;

            break;
        case 4:
            self.ZYSwitchGanShouScore.text = scoreStr;
            self.yuanFeeling = scoreIn;

            break;
        default:
            break;
    }
    return s;
}


- (void)foreButtonView:(ZKForeButtonView *)toolBar clickButton:(UIButton *)button type:(NSString *)type
{
    //NSLog(@"%@-- %@",toolBar,button);
    if ([type isEqualToString:@"zhuyuan"]) {
        self.yuanDay=[NSString stringWithFormat:@"%zd",(button.tag+1)];
    }
}
- (UILabel *)scoreWithlabel
{
    UILabel *score=[[UILabel alloc]initWithFrame:CGRectMake(self.ZYSwitchGanShou.width-50, 0, 50, 30)];
    score.text=@"0.0分";
    score.textColor = HuihaoRedBG;
    score.font=[UIFont systemFontOfSize:13.0];
    score.textAlignment = NSTextAlignmentRight;
    return score;
}

- (void)optionZhengZhuangViewController:(ZKOptionZhengZhuangViewController *)switchI switchWithItem:(NSString *)str
{
    [self.ZYSwitchZhengZhuang setTitle:str forState:UIControlStateNormal];
    self.symptomDescription = self.ZYSwitchZhengZhuang.titleLabel.text;
}
- (void)switchItem:(ZKSitchBingController *)switchI switchWithItem:(ZKBingModel *)bingMoel
{
    [self.ZYSwitchBingBT setTitle:bingMoel.diseaseName forState:UIControlStateNormal];
    self.diseaseId = bingMoel.diseaseId;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (IBAction)optionButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.isShowOptionView) {
    self.optionViewHeight.constant = 0;
        [self.optionChildView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }else
    {
    self.optionViewHeight.constant = 284;
        [self.optionChildView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
    }
    self.isShowOptionView = !self.isShowOptionView;
        [self.optionChildView layoutIfNeeded];
}

- (IBAction)ZYSwitchBingAction:(UIButton *)sender {
    ZKSitchBingController *switchVC=[[ZKSitchBingController alloc]init];
    switchVC.delegate    = self;
    switchVC.title=@"选择病种";
    switchVC.keshiModel  = self.keshiModel;
    switchVC.doctorModel = self.doctorModel;

    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:switchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (IBAction)ZYSwitchZhengZhuangAction:(UIButton *)sender {
    ZKOptionZhengZhuangViewController *switchVC=[[ZKOptionZhengZhuangViewController alloc]init];
    switchVC.delegate                 = self;
    switchVC.keshiModel               = self.keshiModel;
    switchVC.doctorModel              = self.doctorModel;

    ZKNavViewController *nav=[[ZKNavViewController alloc]initWithRootViewController:switchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (IBAction)ZYSwitchImage:(UIButton *)sender {
    ZYQAssetPickerController *picker  = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection =(4- self.photoImages.count);
    picker.assetsFilter               = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups            = NO;
    picker.delegate                   = self;
    picker.selectionFilter            = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
    NSTimeInterval duration           = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];

    [self presentViewController:picker animated:YES completion:NULL];

}

-(NSMutableArray *)photoImages
{
    if (!_photoImages) {
        _photoImages=[NSMutableArray array];
    }
    return _photoImages;
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    //判断photoImages是否超过4张
    if ((self.photoImages.count+assets.count)>4) {
        [MBProgressHUD showError:@"最多只能选择4张照片"];
        return;
    }
    //每次选择照片子后，都将self.imageContent.subviews清空
    [self.ZYSwitchPhotoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    //循环添加image到self.photoImages;
    for (int i = 0; i<assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.photoImages addObject:tempImg];

    }

    //根据self.photoImages;计算imageview的个数以及位置
    [self ReloadImages];

}
- (void)ReloadImages
{

    for (int i                        = 0; i<self.photoImages.count; i++) {
        ZKClearImageView *imgview=[[ZKClearImageView alloc] initWithFrame:CGRectMake((imageW+imageMargin)*i, 0, imageW,imageW)];
    imgview.delegate                  = self;
    imgview.tag                       = i;
    imgview.contentMode               = UIViewContentModeScaleAspectFill;
    imgview.clipsToBounds             = YES;
        [imgview setImage:self.photoImages[i]];
        [self.ZYSwitchPhotoView addSubview:imgview];
    }
    self.addImageBTN.frame            = CGRectMake((imageW+imageMargin)*self.photoImages.count, 0, imageW,imageW);
    if (self.photoImages.count==4) {
        [self.addImageBTN removeFromSuperview];
    }else
    {
        [self.ZYSwitchPhotoView addSubview:self.addImageBTN];

    }
}

- (IBAction)sendJingzi:(UIButton *)sender {
    ZKpennantsViewController *penVC=[[ZKpennantsViewController alloc]init];
    penVC.title=@"送锦旗";
    penVC.keshiModel                  = self.keshiModel;
    [self.navigationController pushViewController:penVC animated:YES];
}
- (IBAction)sendCommit:(UIButton *)sender {
    if (self.isCommentByStatus == ZKCommentStateDepartmentZY) {
        [MBProgressHUD showError:@"今天评价次数已满，请明天在来！"];
        return;
    }
    
    

    if (self.diseaseId==nil) {
        [MBProgressHUD showError:@"请选择病种"];
        return;
    }
    if (self.yuanDay.length == 0){
        [MBProgressHUD showError:@"请选择住院天数"];
        return;
    }

    /** 主治医师分数*/
    if ([self.majorSkill isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请选择主治治疗分数"];
        return;
    }
    /** 护士服务分数*/
    if ([self.nurseService isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请选择护士服务分数"];
        return;
    }
    /** 病房环境*/
    if ([self.environment isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请选择病房环境"];
        return;
    }
    /** 护士服务分数*/
    if ([self.taste isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请选择饭菜可口"];
        return;
    }
    /** 整体感受*/
    if ([self.yuanFeeling isEqualToString:@"0.0"]) {
        [MBProgressHUD showError:@"请选择整体评分"];
        return;
    }
    /** 门诊药品费用*/
    //self.operationCost=self.ZYSwitchYaopinFree.text;
    /** 门诊检查费用*/
    self.yuanCost = self.ZYSwitchJianChaFree.text;
    /** 症状描述*/
    self.symptomDescription = self.ZYSwitchZhengZhuang.titleLabel.text;
    /** 描述120字*/
    self.yuanDescription = self.textView.text;

    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@",userModel.sessionId);
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    NSString *departmentId = self.keshiModel.departmentId;
    if (departmentId.length == 0) {
        departmentId = self.doctorModel.departmentId;
    }
    
    [params setValue:departmentId forKey:@"departmentId"];
    [params setValue:self.diseaseId forKey:@"diseaseId"];
    [params setValue:userModel.userId forKey:@"userId"];
    [params setValue:self.yuanDay forKey:@"yuanDay"];
    [params setValue:self.majorSkill forKey:@"majorSkill"];
    [params setValue:self.nurseService forKey:@"nurseService"];
    [params setValue:self.environment forKey:@"environment"];
    [params setValue:self.recovery forKey:@"recovery"];
    [params setValue:self.yuanFeeling forKey:@"yuanFeeling"];
    [params setValue:self.taste forKey:@"taste"];

        if (![self.yuanCost isEqualToString:@""]) {
            [params setValue:self.yuanCost forKey:@"yuanCost"];
        }
        if (!([self.symptomDescription isEqualToString:@"点击选择症状"] || [self.symptomDescription isEqualToString:@""])) {
            [params setValue:self.symptomDescription forKey:@"symptomDescription"];
        }
        if (![self.yuanDescription isEqualToString:@""] ) {
            [params setValue:self.yuanDescription forKey:@"yuanDescription"];
        }
        if (self.operationCost!=nil) {
            [params setValue:self.operationCost forKey:@"operationCost"];
               }

    NSLog(@"%@",params);
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [MBProgressHUD showMessage:@"发表中..."];
    [manager POST:[NSString stringWithFormat:@"%@inter/keshi/addPjzy.do",baseUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.photoImages.count==0) {
            return ;
    }NSDateFormatter *formatter       = [[NSDateFormatter alloc] init];
    formatter.dateFormat              = @"yyyyMMddHHmmss";
    for (int i                        = 0; i<self.photoImages.count; i++) {
            // 设置时间格式
    NSString *str                     = [formatter stringFromDate:[NSDate date]];
            NSString *name=[NSString stringWithFormat:@"%@%d", str, i+1];
    NSString *fileName                = [NSString stringWithFormat:@"%@.png", str];
            NSLog(@"%@",fileName);
            //循环的时候每个data 给不同的 fileName就可以在一个post请求里发送多个图片了
            // 拼接文件数据
    NSData *data                      = UIImageJPEGRepresentation(self.photoImages[i], 1.0);
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
        }

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [MBProgressHUD hideHUD];
        if ([ZKCommonTools JudgeState:responseObject controller:nil]) {
            [MBProgressHUD showSuccess:@"评价成功"];
            ZKCommonSuccessController *vc=[[ZKCommonSuccessController alloc]init];
            vc.title=@"评价成功";
            [MBProgressHUD hideHUD];
            vc.keshiModel  = self.keshiModel;
            vc.doctorModel = self.doctorModel;
            vc.isKeshi     = true;
            [self.navigationController pushViewController:vc animated:YES];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUD];
    }];
}

- (void)clearImageView:(ZKClearImageView *)clearImageView
{
    [self.photoImages removeObject:clearImageView.image];
    [self.ZYSwitchPhotoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self ReloadImages];
}


@end
