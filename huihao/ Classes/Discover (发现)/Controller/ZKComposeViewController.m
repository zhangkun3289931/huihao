//
//  ZKComposeViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/19.
//  Copyright © 2015年 张坤. All rights reserved.
//
#import "ZKComposeViewController.h"
#import "ZKRedioButton.h"
#import "ZKTextView.h"
#import "huihao.pch"
#import "ZKUserTool.h"
#import "ZKHTTPTool.h"
#import "ZYQAssetPickerController.h"
#import "ZKComposeViewController.h"
#import "ZKNavViewController.h"
#import "ZKClearImageView.h"
#import "ZKLoginViewController.h"
#import "ZKSwitchBingController.h"
@interface ZKComposeViewController () <UITextViewDelegate,ZYQAssetPickerControllerDelegate,ZKClearImageViewDelagate,UINavigationControllerDelegate,ZKSwitchBingControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *topicTitle;
@property (strong, nonatomic) IBOutlet UIView *topicContent;
@property (strong, nonatomic) IBOutlet UIButton *buttonOption;
@property (strong, nonatomic) ZKTextView *textView;
@property (strong, nonatomic) IBOutlet UIView *imageContent;
@property (strong, nonatomic) NSMutableArray *photoImages;
@property (copy, nonatomic) NSString *articleTitle;
@property (copy, nonatomic) NSString *articleContent;
@property (assign, nonatomic) NSInteger isNickF;
@property (strong, nonatomic)  UIButton *addImageBTN;
@property (strong, nonatomic)  NSMutableArray *nextStrs;

- (IBAction)optionBingAction:(UIButton *)sender;
- (IBAction)topicPhonto:(UIButton *)sender;
- (IBAction)isNick:(UIButton *)sender;
- (IBAction)composeAnswerAction:(ZKRedioButton *)sender;

@end
#define imageMargin  2
#define imageW  ((self.imageContent.width-imageMargin*3)*0.25)

@implementation ZKComposeViewController
- (UIButton *)addImageBTN
{
    if (!_addImageBTN) {
        _addImageBTN=[UIButton buttonWithType:UIButtonTypeCustom];
       // [_addImageBTN setTitle:@"+" forState:UIControlStateNormal];
                [_addImageBTN setImage:[UIImage imageNamed:@"common_addImage"] forState:UIControlStateNormal];
        [_addImageBTN setBackgroundColor:QianLVColor];
        [_addImageBTN setTitleColor:ShenLVColor forState:UIControlStateNormal];
        [_addImageBTN addTarget:self action:@selector(topicPhonto:) forControlEvents:UIControlEventTouchUpInside];
        _addImageBTN.frame=CGRectMake(imageMargin, 0, imageW,imageW+6);
    }
    return _addImageBTN;
}
- (NSMutableArray *)photoImages
{
    if (!_photoImages) {
        _photoImages=[NSMutableArray array];
    }
    return _photoImages;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled=self.textView.hasText;
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (NSMutableArray *)nextStrs
{
    if (!_nextStrs) {
        _nextStrs=[NSMutableArray array];
    }
    return _nextStrs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提问";
    
       self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
   // self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"我要发表" style:UIBarButtonItemStylePlain target:self action:@selector(composeTopic:)];
    
    [self.topicTitle becomeFirstResponder];
    
    [self setupUI];
    
    [self.imageContent addSubview:self.addImageBTN];
}
- (void)setupUI
{
    //  UITextField ;
    ZKTextView *textView=[[ZKTextView alloc]initWithFrame:self.topicContent.bounds];
    textView.font=[UIFont systemFontOfSize:13];
    textView.borderClolor = [UIColor whiteColor];
     textView.placeHoder = @"请在这里描述您的问题（最多可以输入250个字）";
    textView.placeClolor = HuihaoBingTextColor;
    textView.alwaysBounceVertical=YES;//让textView在任何状态下都可以拖拽
    textView.delegate=self;
    //想让文字跟着一起懂， 可以使用uilabel
    [self.topicContent addSubview:textView];
    self.textView=textView;

}

#pragma mark -UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)topicPhonto:(UIButton *)sender {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection =(3- self.photoImages.count);
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    //int count=(int)self.imageContent.subviews.count;
   
    //判断photoImages是否超过4张
    if ((self.photoImages.count+assets.count)>3) {
        [MBProgressHUD showError:@"最多只能选择3张照片"];
        return;
    }
     //每次选择照片子后，都将self.imageContent.subviews清空
    [self.imageContent.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    //循环添加image到self.photoImages;
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
         [self.photoImages addObject:tempImg];
    }
    
    //根据self.photoImages;计算imageview的个数以及位置
    [self ReloadImages];
}
- (void)ReloadImages
{
  
    for (int i=0; i<self.photoImages.count; i++) {
        ZKClearImageView *imgview=[[ZKClearImageView alloc] initWithFrame:CGRectMake((imageW+imageMargin)*i, 0, imageW,imageW)];
        imgview.delegate=self;
        imgview.tag=i;
        imgview.contentMode=UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds=YES;
        [imgview setImage:self.photoImages[i]];
        [self.imageContent addSubview:imgview];
    }
     self.addImageBTN.frame=CGRectMake((imageW+imageMargin)*self.photoImages.count, 0, imageW,imageW);
    if (self.photoImages.count==3) {
        [self.addImageBTN removeFromSuperview];
    }else
    {
        [self.imageContent addSubview:self.addImageBTN];

    }
}
- (void)clearImageView:(ZKClearImageView *)clearImageView
{
    [self.photoImages removeObject:clearImageView.image];
    NSLog(@"%zd",self.photoImages.count);
    //每次选择照片子后，都将self.imageContent.subviews清空
    [self.imageContent.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self ReloadImages];
}
- (IBAction)isNick:(UIButton *)sender {
    sender.selected=!sender.isSelected;
    self.isNickF=sender.isSelected;
}

- (IBAction)composeAnswerAction:(ZKRedioButton *)sender {
    
    [self composeTopic:sender];
}

- (void)composeTopic:(UIButton *)sender {
    // NSLog(@"%@",self.colnmuModel.columnId);
    
    self.articleContent=self.textView.text;
    self.articleTitle=self.topicTitle.text;
    
    
    if (self.articleContent.length == 0) {
        [MBProgressHUD showError:@"请输入问题"];
        return;
    }

    //0.判断服务器是否重启
    [ZKUserTool judgeIsLogin];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZKUserModdel *userModel=[ZKUserTool user];
        if (userModel==nil) {
            ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
            [self.navigationController presentViewController:login animated:YES completion:nil];
            return;
        }
        if (self.nextStrs.count==0) {
            [MBProgressHUD showError:@"请选择病种"];
            return;
        }
    
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setValue:userModel.sessionId forKey:@"sessionId"];
        [params setValue:userModel.userId forKey:@"userId"];
        [params setValue:[NSString stringWithFormat:@"%zd",self.isNickF] forKey:@"anonymous"];
        //NSString *title=self.navigationItem.title;
        [params setValue:self.colnmuModel.columnId forKey:@"columnId"];
        [params setValue:self.articleContent forKey:@"articleContent"];
        [params setValue:self.buttonOption.titleLabel.text forKey:@"tags"];
        [params setValue:@"title" forKey:@"articleTitle"];
        
        [MBProgressHUD showMessage:@"发表中..."];
        
        [self composeType:@"inter/wenzhang/addWenzhang.do" params:params];
    });
    
    
    
}

- (void)composeType:(NSString *)url params:(NSDictionary *)params
{
  
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",baseUrl,url] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        for (int i=0; i<self.photoImages.count; i++) {
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
        //NSLog(@"%@",responseObject);
        if ([ZKCommonTools JudgeState:responseObject controller:nil]){
            NSString *state= [responseObject objectForKey:@"state"];
            if (StateTypeNoLogin==state.intValue) {
                ZKLoginViewController *login=[[ZKLoginViewController alloc]init];
                [self.navigationController presentViewController:login animated:YES completion:nil];
            }
            [MBProgressHUD showMessage:@"发表成功"];
            
            if ([self.delegate respondsToSelector:@selector(composeViewController:withBingName:)]) {
                
                [self.delegate composeViewController:self withBingName:self.nextStrs.firstObject];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
}
- (IBAction)optionBingAction:(UIButton *)sender {
   
    ZKSwitchBingController *vc=[[ZKSwitchBingController alloc]init];
    vc.title=@"选择病种";
    vc.delagate=self;
    [self.navigationController presentViewController:[[ZKNavViewController alloc]initWithRootViewController:vc] animated:YES completion:nil];
}
- (void)switchItem:(ZKSwitchBingController *)switchI switchWithItem:tags{
 
    
    self.nextStrs = tags;
    NSMutableString *nulString=[NSMutableString stringWithString:@""];
    [tags enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nulString appendFormat:@"%@,",obj];
    }];
    
    [self.buttonOption setTitle:[nulString substringToIndex:nulString.length-1] forState:UIControlStateNormal];
}
@end
