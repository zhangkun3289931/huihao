//
//  ZKChangeIndoDAataViewController.m
//  huihao
//
//  Created by 张坤 on 15/9/20.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import "ZKChangeIndoDAataViewController.h"
#import "ZKUserTool.h"
#import "ZHPickView.h"
#import "ZKHTTPTool.h"
#import "ZKConst.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "ZKCommonTools.h"
#import "UIView+Extension.h"
#import "huihao.pch"
@interface ZKChangeIndoDAataViewController () <ZHPickViewDelegate,UIActionSheetDelegate>

- (IBAction)infoDataClick:(UIButton *)sender;
- (IBAction)infoSexClick:(UIButton *)sender;
- (IBAction)infoDateClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *infoIcon;
@property (strong, nonatomic) IBOutlet UILabel *infoName;
@property (strong, nonatomic) IBOutlet UITextField *infoNameTF;
@property (strong, nonatomic) IBOutlet UIButton *infoSexBT;
@property (strong, nonatomic) IBOutlet UITextField *infoPhone;
@property (strong, nonatomic) IBOutlet UIButton *infoDateBT;
@property (strong, nonatomic) IBOutlet UILabel *inviteCodeLb;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) ZKUserModdel *user;
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,copy)NSString *tag;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *birthday;

@end

@implementation ZKChangeIndoDAataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 监听键盘弹出事件
    [self keyboaedNoti];
    //2. 初始化icon
    [self setupIconInfo];
    //3. 第一次进来的时候，初始化缓存用户信息
    [self setupUserInfo];
    //4. 初始化NAv
    [self setupNav];
}
- (void)dealloc
{
    [ZKNotificationCenter removeObserver:self];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_pickview removeFromSuperview];
    [self.view endEditing:YES];
}
//初始化icon信息
- (void)setupIconInfo
{
    self.infoIcon.layer.cornerRadius = self.infoIcon.width * 0.5;
    self.infoIcon.layer.borderWidth = 2;
    self.infoIcon.layer.borderColor= HuihaoRedBG.CGColor;
    self.infoIcon.layer.masksToBounds = YES;
}
/**
 *  第一次进来的时候初始化用户信息
 */
- (void)setupUserInfo
{
    self.user=[ZKUserTool user];
    
    if (self.user) {
        NSString *name = self.user.nickName;
        if (name.length == 0) {
            name = self.user.username;
        }
        
        self.infoName.text = name;
        self.infoNameTF.text = self.user.nickName;
        
        NSString *sexName;
        switch (self.user.sex.intValue) {
            case SexTypeBoy:
                sexName = @"男";
                break;
            case SexTypeGril:
                sexName = @"女";
                break;
            case SexTypeNo:
                sexName = @"不详";
                break;
        }
        [self.infoSexBT setTitle:sexName forState:UIControlStateNormal];
        self.infoPhone.text=self.user.phone;
        [self.infoDateBT setTitle:self.user.birthday forState:UIControlStateNormal];
        self.inviteCodeLb.text=self.user.inviteCode;
        [self.infoIcon.imageView sd_setImageWithURL:[NSURL URLWithString:self.user.imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.infoIcon setImage:image forState:UIControlStateNormal];
        }];
    }

}
/**
 *  初始化nav
 */
- (void)setupNav
{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(editInfo)];
}

/**
 *  监听键盘的事件
 */
- (void)keyboaedNoti
{
    [ZKNotificationCenter addObserver:self selector:@selector(kbFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)kbFrameChange:(NSNotification *)noti
{
    [_pickview removeFromSuperview];
}
- (void)editInfo
{
    /**  姓名*/
    self.name=self.infoNameTF.text;
    NSRange infoNameRange=[self.name rangeOfString:@" "];
    NSLog(@"%@",NSStringFromRange(infoNameRange));
    if (infoNameRange.length>0) {
        [MBProgressHUD showError:@"姓名中不能包含空格"];
        return;
    }
    
    if (self.name.length>8) {
        [MBProgressHUD showError:@"姓名的长度不能大于八位"];
        return;
    }
    /** 门诊检查费用*/
    self.tel=self.infoPhone.text;
    /** sex*/
    //self.sex=self.infoSexBT.titleLabel.text;
    /** date*/
    self.birthday=self.infoDateBT.titleLabel.text;
    
  
    
    ZKUserModdel *userModel=[ZKUserTool user];
    //NSLog(@"%@",userModel.sessionId);
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
    [params setValue:userModel.userId forKey:@"userId"];
    if (![self.name isEqualToString:@""]) {
        [params setValue:self.name forKey:@"name"];
    }
    if (![self.tel isEqualToString:@""]) {
        [params setValue:self.tel forKey:@"tel"];
    }
    if (![self.sex isEqualToString:@""] ) {
        [params setValue:self.sex forKey:@"sex"];
    }
    if (self.birthday!=nil) {
        [params setValue:self.birthday forKey:@"birthday"];
    }
    
    [ZKHTTPTool POST:[NSString stringWithFormat:@"%@inter/user/modifyDes.do",baseUrl] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        
        if ([ZKCommonTools JudgeState:json controller:nil]) {
            self.user.phone=self.tel;
            switch (self.sex.intValue) {
                case SexTypeBoy:
                    self.user.sex=@"男";
                    break;
                case SexTypeGril:
                    self.user.sex=@"女";
                    break;
                case SexTypeNo:
                    self.user.sex=@"不详";
                    break;
                default:
                    break;
            }
            self.user.birthday = self.birthday;
            self.user.nickName = self.name;
 
            [ZKUserTool saveAccount:self.user];
            [MBProgressHUD showSuccess:@"修改成功"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
         [MBProgressHUD hideHUD];
    }];
}

#pragma mark - action
- (IBAction)infoDataClick:(UIButton *)sender {
       [_pickview removeFromSuperview];
        [self.view endEditing:YES];
    
       UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"请选择照片源？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"照片", nil];
        [sheet showInView:self.view];
}
- (IBAction)infoSexClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.pickview) {
        [self.pickview removeFromSuperview];
    }
    
    self.pickview=[[ZHPickView alloc]initPickviewWithPlistName:@"一组数据" isHaveNavControler:NO];
    self.tag=@"0";
    [self.pickview setToolbarTintColor:[UIColor lightGrayColor]];
    self.pickview.delegate=self;
    [self.pickview show];
}
- (IBAction)infoDateClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.pickview) {
        [self.pickview removeFromSuperview];
    }
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    self.pickview=[[ZHPickView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    [self.pickview setToolbarTintColor:[UIColor lightGrayColor]];
    self.pickview.delegate=self;
    self.tag=@"1";
    [self.pickview show];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex) {
        case SourceTypeCamera:
            [self openCamera];
            break;
        case SourceTypeLibary:
            [self openAlbum];
            break;
        default:
            break;
    }
}
/**
 *  打开照相机
 */
- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
/**
 *  打开相册
 */
- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.infoIcon setImage:image forState:UIControlStateNormal];
    
    [self headUpload:image];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_pickview removeFromSuperview];
    [self.view endEditing:YES];
}
- (void)headUpload:(UIImage *)image
{
    ZKUserModdel *userModel=[ZKUserTool user];
    [MBProgressHUD showMessage:@"上传照片中..."];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setValue:userModel.sessionId forKey:@"sessionId"];
     [params setValue:userModel.userId forKey:@"userId"];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"%@inter/user/uploadHeadIcon.do",baseUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            // 设置时间格式
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
             // NSLog(@"%@",fileName);
                // 拼接文件数据
                NSData *data = UIImageJPEGRepresentation(image, 0.1);
                [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"上传成功"];
            NSString *iconURl= [[responseObject objectForKey:@"body"] objectForKey:@"headIcon"];
            self.user.imagePath=iconURl;
            [ZKUserTool saveAccount:self.user];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUD];
        }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSLog(@"%@",resultString);
    if ([self.tag isEqualToString:@"0"]) {
        [self.infoSexBT setTitle:resultString forState:UIControlStateNormal];
        if ([resultString isEqualToString:@"男"]) {
            self.sex=@"0";
        }else if ([resultString isEqualToString:@"女"]){
                self.sex=@"1";
            }
        
    }else if ([self.tag isEqualToString:@"1"])
    {
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];//真机调试要加上这句代码
        //EEE MMM dd HH:mm:ss Z yyyy
        //设置日期的格式，生命字符串里面每个数字的含义
        //2015-09-16 10:22:15
        df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
        //NSDate *createDate=[df dateFromString:resultString];
       // NSString *createDataStr=[df stringFromDate:createDate];
        [self.infoDateBT setTitle:[resultString substringToIndex:resultString.length-15] forState:UIControlStateNormal];
    }
}


@end
