//
//  YFInputBar.m
//  test
//
//  Created by 杨峰 on 13-11-10.
//  Copyright (c) 2013年 杨峰. All rights reserved.

#import "YFInputBar.h"
#import "AppDelegate.h"
#import "ZKTextView.h"
//#import "KeyboardToolBar.h"
@implementation YFInputBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        self.frame = CGRectMake(0, CGRectGetMinY(frame), self.width, CGRectGetHeight(frame));
        
        self.textField.tag = 10000;
        self.sendBtn.tag = 10001;
        self.nickBtn.tag = 10002;
        
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _originalFrame = frame;
}
//_originalFrame的set方法  因为会调用setFrame  所以就不在此做赋值；
-(void)setOriginalFrame:(CGRect)originalFrame
{
    self.frame = CGRectMake(0, CGRectGetMinY(originalFrame), self.width, CGRectGetHeight(originalFrame));
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark get方法实例化输入框／btn
- (UIButton *)nickBtn
{
    if (!_nickBtn) {
        _nickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_nickBtn setAdjustsImageWhenHighlighted:NO];
        [_nickBtn setImage:[UIImage imageNamed:@"nick_blue"] forState:UIControlStateSelected];
        [_nickBtn setImage:[UIImage imageNamed:@"nick_gray"] forState:UIControlStateNormal];
        
        _nickBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_nickBtn setFrame:CGRectMake(10, 8, 30, 30)];
        [_nickBtn addTarget:self action:@selector(snedNickBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nickBtn];

    }
    return _nickBtn;
}

-(ZKTextView *)textField
{
    if (!_textField) {
        _textField = [[ZKTextView alloc]initWithFrame:CGRectMake(50, 5, 200, 34)];
     //   [KeyboardToolBar unregisterKeyboardToolBarWithTextView:_textField];
        _textField.backgroundColor = HuihaoBG;
        _textField.borderClolor = [UIColor whiteColor];
        _textField.placeHoder=@"你输入你的答案";
        [self addSubview:_textField];
    }
    return _textField;
}
-(UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setImage:[UIImage imageNamed:@"nick_send"] forState:UIControlStateNormal];
        [_sendBtn setFrame:CGRectMake(270, 10, 40, 24)];
        [_sendBtn addTarget:self action:@selector(sendBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}
#pragma mark selfDelegate method

-(void)sendBtnPress:(UIButton*)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inputBar:sendBtnPress:withInputString:)]) {
        [self.delegate inputBar:self sendBtnPress:sender withInputString:self.textField.text];
    }
    if (self.clearInputWhenSend) {
        self.textField.text = @"";
    }
    if (self.resignFirstResponderWhenSend) {
        [self resignFirstResponder];
    }
}
- (void)snedNickBtnPress:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    [self.delegate inputBar:self nickBtnPress:sender];
}

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)notification{
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%f-%f-%f-%f",_keyboardRect.origin.y,_keyboardRect.size.height,[self getHeighOfWindow]-CGRectGetMaxY(self.frame),CGRectGetMinY(self.frame));
    
    //如果self在键盘之下 才做偏移
    if ([self convertYToWindow:CGRectGetMaxY(self.originalFrame)]>=_keyboardRect.origin.y)
    {
        //没有偏移 就说明键盘没出来，使用动画
        if (self.frame.origin.y== self.originalFrame.origin.y) {
            
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.transform = CGAffineTransformMakeTranslation(0, -_keyboardRect.size.height+[self getHeighOfWindow]-CGRectGetMaxY(self.originalFrame));
                             } completion:nil];
        }
        else
        {
            self.transform = CGAffineTransformMakeTranslation(0, -_keyboardRect.size.height+[self getHeighOfWindow]-CGRectGetMaxY(self.originalFrame));
        }
        
    }
    
}

- (void)keyboardWillHide:(NSNotification*)notification{
    

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, 0);
                     } completion:nil];
}
#pragma  mark ConvertPoint
//将坐标点y 在window和superview转化  方便和键盘的坐标比对
-(float)convertYFromWindow:(float)Y
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CGPoint o = [appDelegate.window convertPoint:CGPointMake(0, Y) toView:self.superview];
    return o.y;
    
}
-(float)convertYToWindow:(float)Y
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CGPoint o = [self.superview convertPoint:CGPointMake(0, Y) toView:appDelegate.window];
    return o.y;
    
}
-(float)getHeighOfWindow
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate.window.frame.size.height;
}

-(BOOL)resignFirstResponder
{
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}
@end
