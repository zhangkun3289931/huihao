//
//  BoSectionBackgroundLayout.m
//  CollectionSectionView
//
//  Created by AlienJunX on 15/9/9.
//  Copyright (c) 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoSectionBackgroundLayout.h"
#import "BoSectionBgReusableView.h"
#define kItemHeight 20
#define kMinimumLineSpacing 2
#define kMinimumInteritemSpacing 5

#define kSectionEdgeInsetsLeft 5
#define kSectionEdgeInsetsBottom 0
#define kSectionEdgeInsetsTop 5
#define kSectionEdgeInsetsRight 5

@interface BoSectionBackgroundLayout()
@end

@implementation BoSectionBackgroundLayout


- (void)prepareLayout{
    [super prepareLayout];
    
    //1. 控制item之间的间距
    self.collectionView.contentInset = UIEdgeInsetsMake(kSectionEdgeInsetsTop, kSectionEdgeInsetsLeft, kSectionEdgeInsetsBottom, kSectionEdgeInsetsRight);
    //2. 控制line的间距
    //self.minimumLineSpacing = 5;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    //1. 获取在rect范围内，所有item的layoutAttributes属性数组
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    NSLog(@"%@",attributes);

    
     for(int i = 1; i < [attributes count]; ++i) {

        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //获取上一个prevLayoutAttributes的最右边X值
        CGFloat prevOriginX = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        //获取获取这次本来的应该呆的位置
        CGFloat  beginWith = prevOriginX + kMinimumInteritemSpacing + currentLayoutAttributes.frame.size.width ;
        
        //距离collection边缘的距离
        CGFloat rightCollection = self.collectionViewContentSize.width - self.sectionInset.right;
    
        if(beginWith <= rightCollection) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = prevOriginX + kMinimumInteritemSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}
@end
