//
//  ZKClearLabel.h
//  huihao
//
//  Created by 张坤 on 15/11/23.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKClearLabel;
@protocol ZKClearLabelDelagate <NSObject>
@optional
- (void)clearLabel:(ZKClearLabel *)clearLabel;

@end

@interface ZKClearLabel : UILabel
@property (weak,nonatomic) id<ZKClearLabelDelagate> delegate;
@end
