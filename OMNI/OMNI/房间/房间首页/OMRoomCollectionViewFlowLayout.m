//
//  OMRoomCollectionViewFlowLayout.m
//  OMNI
//
//  Created by changxicao on 16/6/3.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "OMRoomCollectionViewFlowLayout.h"

#define kMinimumLineSpacing -SCREENHEIGHT / 20.0f
#define kScale 0.8f

@implementation OMRoomCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    // 设置为水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    // 设置内边距
    CGFloat insetGap = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, insetGap, 0, insetGap);
    self.minimumLineSpacing = kMinimumLineSpacing;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat x = ABS(self.collectionView.contentOffset.x);
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    CGFloat centerX = x + CGRectGetWidth(self.collectionView.frame) / 2.0f;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat gapX = ABS(attributes.center.x - centerX);
        CGFloat scale = (1 - gapX / CGRectGetWidth(self.collectionView.frame)) * kScale;
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;

}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + CGRectGetWidth(self.collectionView.bounds) / 2.0f;
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0f, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];

    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}


@end
