//
//  ZKStatusPhotoView.h
//  微博
//
//  Created by 张坤 on 15/9/7.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ZKStatusPhotoView;
#define kCellBorderW 2
#define kCellPhoneW 100
//#define HWStatusPhotoMaxCol(count) ((count==2)?2:3)

@protocol ZKStatusPhotoViewDelegate <NSObject>

// 1. 选中单元格
- (void)ZKStatusPhotoView:(ZKStatusPhotoView *)statusPhotoView didSelectRowAtIndexPath:(NSString *)indexPath;

@end

@interface ZKStatusPhotoView : UIView
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) NSArray *photos;
// image的全部frame
@property (strong, nonatomic) NSMutableArray *imageFrameArray;
@property (nonatomic,weak) id<ZKStatusPhotoViewDelegate> delegate;
+ (CGSize)sizeWithPhontCount:(NSUInteger)count;
@end
