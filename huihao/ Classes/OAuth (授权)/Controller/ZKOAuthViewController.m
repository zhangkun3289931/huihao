
//
//  ZKOAuthViewController.m
//  微博
//
//  Created by 张坤 on 15/9/3.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKOAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "ZKOAuth.h"
#import "ZKOAuthTool.h"
#import "UIWindow+ZKExtension.h"
#import "ZKConst.h"

@interface ZKOAuthViewController() <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end
@implementation ZKOAuthViewController
-(UIWebView *)webView
{
    if (!_webView) {
        _webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
        
        _webView.delegate=self;
        NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",kClient_id,kRedirect_uri]]];
        [_webView loadRequest:urlRequest];
    }
    return _webView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
}
#pragma -mark webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
   [MBProgressHUD showMessage: LoaderString(@"httpLoadText")];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [MBProgressHUD hideHUD];

   NSString *url= request.URL.absoluteString;
    //判断是否是回调地址
   NSRange range= [url rangeOfString:@"code="];
    if (range.length!=0) {
        int formIndex=(int)(range.location+range.length);
        NSString *code=[url substringFromIndex:formIndex];
        //用code换取accesToken
        [self accessTokenWithCode:code];
        //禁止加载回调地址
        return NO;
    }
    
    
    return YES;
}
/**
 *  获取accessToken
 *
 *  @param code <#code description#>
 */
-(void)accessTokenWithCode:(NSString *)code
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //manager.responseSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *params=@{
                           @"client_id":kClient_id,
                           @"client_secret":kClient_secret,
                           @"code":code,
                           @"grant_type":@"authorization_code",
                           @"redirect_uri":kRedirect_uri
                           };
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
       ZKOAuth *oauth= [ZKOAuth oauthWithDict:responseObject];
        [ZKOAuthTool save:oauth];
        //切换控制器
        [[UIApplication sharedApplication].keyWindow switchRootViewController];
        //将返回来的账号数据存到沙盒
        //[responseObject writeToFile:path atomically:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
@end
