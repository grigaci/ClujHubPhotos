//
//  CPDataEvent.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPDataEvent.h"

@interface CPDataEvent ()

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSDate *date;
@property (nonatomic, readwrite, strong) NSMutableArray *photoFilenames;

@end

@implementation CPDataEvent

NSString const * kEventNameKey = @"name";
NSString const * kEventDateKey = @"date";
NSString const * kEventPhotosKey = @"photos";
NSString const * kEventThumbnail = @"-thumbnail";

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    [self loadFromDictionary:dictionary];
    return self;
}

- (void)loadFromDictionary:(NSDictionary *)dictionary
{
    self.name = dictionary[kEventNameKey];
    self.date = dictionary[kEventDateKey];
    NSDictionary *photosDictionary = dictionary[kEventPhotosKey];
    NSArray *allKeys = [photosDictionary allKeys];
    [self.photoFilenames removeAllObjects];
    for (NSString *key  in allKeys) {
        NSString *photoFileName = photosDictionary[key];
        [self.photoFilenames addObject:photoFileName];
    }
}

- (NSUInteger)countPhotos
{
    return [self.photoFilenames count];
}

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    if (index < [self.photoFilenames count]) {
        NSString *photoFileName = self.photoFilenames[index];
        UIImage *image = [UIImage imageNamed:photoFileName];
        return image;
    }
    return nil;
}

- (UIImage *)thumbnailAtindex:(NSUInteger)index
{
    if (index < [self.photoFilenames count]) {
        NSString *photoFilename = self.photoFilenames[index];
        NSString *thumbnailFilename = [NSString stringWithFormat:@"%@%@", photoFilename, kEventThumbnail];
        UIImage *image = [UIImage imageNamed:thumbnailFilename];
        return image;
    }
    return nil;
}

#pragma mark properties

- (NSMutableArray *)photoFilenames
{
    if (!_photoFilenames) {
        _photoFilenames = [NSMutableArray array];
    }
    return _photoFilenames;
}

@end
