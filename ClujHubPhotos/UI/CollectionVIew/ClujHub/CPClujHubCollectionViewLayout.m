//
//  CPClujHubCollectionViewLayout.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 11/6/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPClujHubCollectionViewLayout.h"

@interface CPClujHubCollectionViewLayout ()

@property (nonatomic, strong) NSMutableDictionary *attributesDictionary;
@property (nonatomic, strong) NSMutableDictionary *headerAttributesDictionary;
@property (nonatomic, strong) NSMutableArray *angles;

@end

@implementation CPClujHubCollectionViewLayout

static CGFloat const kCPCellItemWidth = 150.0;
static CGFloat const kCPCellItemHeight = 120.0;
static CGFloat const kCPHeaderItemHeight = 40.0;
static int const kCPZIndexMultiplier = 100;

- (id) init
{
    self = [super init];
    
    if (self) {
        _cellItemSize = CGSizeMake(kCPCellItemWidth , kCPCellItemHeight);
    }
    return self;
}

- (void)prepareLayout
{
    [self generateAttributesForCells];
    [self generateAttributesForHeaders];
}

- (NSArray *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)kind
{
    if (![kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        return [NSArray array];
    }

    NSMutableArray *array = [NSMutableArray array];
    NSUInteger countSections = [self.collectionView numberOfSections];
    for (int sectionIndex = 0; sectionIndex < countSections; sectionIndex++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
        [array addObject:indexPath];
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.headerAttributesDictionary[indexPath];
    } else {
        return nil;
    }
}

- (void)invalidateLayout
{
    _headerAttributesDictionary = nil;
    _attributesDictionary = nil;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.bounds.size;
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.attributesDictionary[indexPath];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[self.attributesDictionary allValues]];
    [array addObjectsFromArray:[self.headerAttributesDictionary allValues]];
    return array;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

#pragma mark helpers

- (void)generateAttributesForCells
{
    if (_attributesDictionary) {
        return;
    }

    _attributesDictionary = [NSMutableDictionary dictionary];
    CGSize size = self.collectionView.bounds.size;
    CGPoint center = CGPointMake(size.width / 2.0, size.height / 2.0);
    NSUInteger countSections = [self.collectionView numberOfSections];

    for (int sectionIndex = 0; sectionIndex < countSections; sectionIndex++)
    {
        NSInteger countItems = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int itemIndex = 0; itemIndex < countItems; itemIndex++)
        {
            NSInteger angleIndex = itemIndex;
            NSNumber *angleNumber = [self.angles objectAtIndex:angleIndex];
            CGFloat angle = angleNumber.floatValue;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.size = self.cellItemSize;
            attributes.center = center;
            attributes.transform = CGAffineTransformMakeRotation(angle);

            int zIndex = (countSections - sectionIndex) * kCPZIndexMultiplier + countItems - itemIndex;
            attributes.zIndex = zIndex;
            [self.attributesDictionary setObject:attributes forKey:indexPath];
        }
    }
}

- (void)generateAttributesForHeaders
{
    if (_headerAttributesDictionary) {
        return;
    }

    _headerAttributesDictionary = [NSMutableDictionary dictionary];
    NSUInteger countSections = [self.collectionView numberOfSections];

    for (int sectionIndex = 0; sectionIndex < countSections; sectionIndex++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                      withIndexPath:indexPath];
        attributes.size = CGSizeMake(self.collectionView.bounds.size.width, kCPHeaderItemHeight);
        attributes.alpha = 0.0;
        self.headerAttributesDictionary[indexPath] = attributes;
    }
}

#pragma mark properties

- (NSMutableArray *)angles
{
    if (_angles) {
        return _angles;
    }

    _angles = [NSMutableArray array];
    NSUInteger countSections = [self.collectionView numberOfSections];
    for (int sectionIndex = 0; sectionIndex < countSections; sectionIndex++) {
        NSInteger countItems = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int itemIndex = 0; itemIndex < countItems; itemIndex++) {
            [self.angles addObject:[NSNumber numberWithFloat:0]];
            for (NSInteger i = 1; i < countItems; i++) {
                int randomDigit1 = arc4random() % 2;
                int randomDigit2 = arc4random() % 10;
                int randomDigit3 = arc4random() % 10;
                CGFloat floatRandomNr = (randomDigit1 * 100 + randomDigit2 * 10 + randomDigit3) / 100.0;
                if (i%2) floatRandomNr = -floatRandomNr;
                [self.angles addObject:[NSNumber numberWithFloat:floatRandomNr]];
            }
        }
    }
    return _angles;
}

@end
