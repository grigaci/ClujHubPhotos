//
//  CPCollectionViewData.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 11/6/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPCollectionViewData.h"
#import "CPDataManager.h"
#import "CPDataEvent.h"
#import "CPCollectionViewCell.h"
#import "CPCollectionViewHeader.h"

@implementation CPCollectionViewData


NSString * const kCPCollectionViewCell = @"CollectionViewCell";
NSString * const kCPCollectionViewHeader = @"CollectionViewHeader";

static NSString * const kCPEventsViewControllerTitle = @"Photos";
static CGFloat const kCPSectionInsetTop = 0.0;
static CGFloat const kCPSectionInsetBottom = 10.0;
static CGFloat const kCPSectionInsetLeft = 10.0;
static CGFloat const kCPSectionInsetRight = 10.0;

#pragma mark UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = [[[CPDataManager sharedManager] allEvents] count];
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger countItems = 0;
    NSArray *allEvent = [[CPDataManager sharedManager] allEvents];
    if (section < [allEvent count]) {
        CPDataEvent *event = allEvent[section];
        countItems = [event countPhotos];
    }
    return countItems;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 10, 10, 10);
    return insets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCPCollectionViewCell forIndexPath:indexPath];
    NSArray *allEvent = [[CPDataManager sharedManager] allEvents];
    if (indexPath.section < [allEvent count]) {
        CPDataEvent *event = allEvent[indexPath.section];
        UIImage *image = [event thumbnailAtindex:indexPath.row];
        cell.image = image;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CPCollectionViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:kCPCollectionViewHeader
                                                                                         forIndexPath:indexPath];
    NSArray *allEvent = [[CPDataManager sharedManager] allEvents];
    if (indexPath.section < [allEvent count]) {
        CPDataEvent *event = allEvent[indexPath.section];
        [headerView setName:event.name];
        [headerView setDate:event.date];
    }

    return headerView;
}

@end
