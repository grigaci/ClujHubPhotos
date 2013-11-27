//
//  CPEventsCollectionViewLayout.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPEventsCollectionViewLayout.h"
#import "CPCollectionViewHeader.h"

@implementation CPEventsCollectionViewLayout

static CGFloat const kCPCellItemWidth = 80.0;
static CGFloat const kCPCellItemHeight = 80.0;
static CGFloat const kCPHeaderItemWidth = 320.0;
static CGFloat const kCPHeaderItemHeight = 40.0;

static CGFloat const kCPSectionInsetTop = 0.0;
static CGFloat const kCPSectionInsetBottom = 10.0;
static CGFloat const kCPSectionInsetLeft = 10.0;
static CGFloat const kCPSectionInsetRight = 10.0;

- (instancetype)init
{
    self = [super init];
    self.itemSize = CGSizeMake(kCPCellItemWidth, kCPCellItemHeight);
    self.sectionInset = UIEdgeInsetsMake(kCPSectionInsetTop, kCPSectionInsetLeft, kCPSectionInsetBottom, kCPSectionInsetRight);
    self.headerReferenceSize = CGSizeMake(kCPHeaderItemWidth, kCPHeaderItemHeight);
    return self;
}


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *allElements = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *missingSectionHeaders = [NSMutableIndexSet indexSet];

    for (UICollectionViewLayoutAttributes *layoutAttributes in allElements) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSectionHeaders addIndex:layoutAttributes.indexPath.section];
        }
    }

    for (UICollectionViewLayoutAttributes *layoutAttributes in allElements) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSectionHeaders removeIndex:layoutAttributes.indexPath.section];
        }
    }

    [missingSectionHeaders enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [allElements addObject:layoutAttributes];
    }];

    [self repositionSectionHeadersFor:allElements];
    return allElements;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

- (void)repositionSectionHeadersFor:(NSArray *)allElements
{
    UICollectionView * collectionView = self.collectionView;
    CGPoint contentOffset = collectionView.contentOffset;

    for (UICollectionViewLayoutAttributes *layoutAttributes in allElements) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            
            if (numberOfItemsInSection > 0) {
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            } else {
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                        atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                       atIndexPath:lastObjectIndexPath];
            }

            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            NSInteger currentOffsetOnY = contentOffset.y + collectionView.contentInset.top;
            NSInteger startSectionHeaderOnY = (CGRectGetMinY(firstObjectAttrs.frame) - headerHeight);
            NSInteger endSectionHeaderOnY = (CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight);
            origin.y = MIN(
                           MAX(
                               currentOffsetOnY,
                               startSectionHeaderOnY
                               ),
                           endSectionHeaderOnY
                           );

            layoutAttributes.zIndex = INT_MAX;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        }
    }
}

@end
