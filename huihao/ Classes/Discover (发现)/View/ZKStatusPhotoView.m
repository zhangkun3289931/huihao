//
//  ZKStatusPhotoView.m
//  微博
//
//  Created by 张坤 on 15/9/7.
//  Copyright (c) 2015年 张坤. All rights reserved.
//

#import "ZKStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "VIPhotoView.h"
@interface ZKStatusPhotoView()
//记录当前屏幕上的单元格视图
@property (strong, nonatomic) NSMutableDictionary *screenImageDicts;
@end
@implementation ZKStatusPhotoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.screenImageDicts=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:self];
    [self.screenImageDicts enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIImageView *obj, BOOL * _Nonnull stop) {
        if( CGRectContainsPoint(obj.frame, location))
        {
            NSLog(@"%@",NSStringFromCGRect(obj.frame));
            [self.delegate ZKStatusPhotoView:self didSelectRowAtIndexPath:key];
        };
    }];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos=photos;
    
    //让所有的子控件执行这个方法。 不建议使用，因为这样会频繁的创建销毁对象
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建足够数量的imageView
    //    if (self.subviews.count>=photos.count) {// 牵扯到循环利用，cell显示的imageView个数不一样,所以要大于，说明里面的imageview够用，不需要在创建
    //    }
    //来到这个 说明不够用，
    while (self.subviews.count<photos.count) {
        UIImageView *imageView=[[UIImageView alloc]init];
        [ imageView setContentMode: UIViewContentModeScaleToFill | UIViewContentModeTop];
        [imageView setClipsToBounds:YES];
        [self addSubview:imageView];
    }
   // NSLog(@"%@",photos[0][@"imgUrl"]);
    //遍历所有的imageView，设置图片
    for (int i=0; i<self.subviews.count; i++) {
        UIImageView *imageView=self.subviews[i];
        if (i<photos.count) {
            //显示
            imageView.hidden=NO;
            NSString *imagePath= photos[i][@"imgUrl"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imagePath]
                                           ] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
               // imageView.contentMode=UIViewContentModeScaleAspectFill;
           
        }else
        {
            //隐身
            imageView.hidden=YES;
        }
    }
}
- (NSMutableArray *)imageFrameArray
{
    if (!_imageFrameArray) {
        _imageFrameArray=[NSMutableArray array];
    }
    return _imageFrameArray;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger cols;
    NSUInteger rows;
    int maxCol=1;
    CGFloat cellPhoneW=150;
    if (self.photos.count%2==0) {
        maxCol=2;
        cellPhoneW=100;
    }else if (self.photos.count==3)
    {
        maxCol=3;
        cellPhoneW=60;
    }
    
    for (int i=0; i<self.photos.count; i++) {
        UIImageView *imageView=self.subviews[i];
        cols=i%maxCol;
        imageView.x=(cellPhoneW+kCellBorderW)*cols;
        rows=i/maxCol;
        imageView.y=(cellPhoneW+kCellBorderW)*rows;
        imageView.width=cellPhoneW;
        imageView.height=cellPhoneW;
        
        [self.screenImageDicts setObject:imageView forKey:@(i)];
        // CGRect srcFrame=[ convertRect:imageView.frame toView:self];
        [self.imageFrameArray addObject:[NSValue valueWithCGRect:imageView.frame]];
    }
  
}
+ (CGSize)sizeWithPhontCount:(NSUInteger)count
{
    NSUInteger col = 1;
    CGFloat cellPhoneW = 150;
    if (count%2 == 0) {
        col=2;
        cellPhoneW = 100;
    }else if (count == 3)
    {
        col=3;
        cellPhoneW=60;
    }
    CGFloat width = cellPhoneW * col + kCellBorderW * (col-1);
    NSUInteger row=(count + col - 1) / col ; //count/3;
    CGFloat height= cellPhoneW *row + kCellBorderW * (row-1);
    
    NSLog(@"%@",NSStringFromCGSize(CGSizeMake(width, height)));
    return CGSizeMake(width, height);
}
- (UIButton *)cover
{
    if (_cover==nil) {
        _cover = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _cover.alpha=0.0;
        [self addSubview:_cover];
    }
    return _cover;
}

@end
