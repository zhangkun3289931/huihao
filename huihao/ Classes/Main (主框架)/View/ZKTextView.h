//
//  ZKTextView.h
//  微博
//
//  Created by 张坤 on 15/9/8.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKTextView : UITextView
/** 占位文字*/
@property (nonatomic, copy) NSString *placeHoder;
/** 占位文字Color*/
@property (nonatomic, strong) UIColor *placeClolor;
/** 边框Color*/
@property (nonatomic, strong) UIColor *borderClolor;
@end
