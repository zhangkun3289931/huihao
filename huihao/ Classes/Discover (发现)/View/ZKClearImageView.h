//
//  ZKClearImageView.h
//  huihao
//
//  Created by 张坤 on 15/10/21.
//  Copyright © 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKClearImageView;
@protocol ZKClearImageViewDelagate <NSObject>
@optional
- (void)clearImageView:(ZKClearImageView *)clearImageView;

@end
@interface ZKClearImageView : UIImageView
@property (nonatomic,assign) NSInteger imgTag;
@property (nonatomic,weak) id<ZKClearImageViewDelagate> delegate;
@end
