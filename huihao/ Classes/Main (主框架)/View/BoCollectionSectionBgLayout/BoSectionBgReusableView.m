//
//  BoSectionBgReusableView.m
//  CollectionSectionView
//
//  Created by AlienJunX on 15/9/9.
//  Copyright (c) 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoSectionBgReusableView.h"

@interface BoSectionBgReusableView()
@property (weak,nonatomic) UIView *bgview;
@end

@implementation BoSectionBgReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *v = [[UIView alloc] init];

        [self addSubview:v];
        _bgview = v;
        _bgview.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_bgview]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bgview)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bgview)]];
    }
    return self;
}


@end
