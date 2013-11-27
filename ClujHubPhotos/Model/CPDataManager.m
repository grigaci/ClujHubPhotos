//
//  CPDataManager.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPDataManager.h"
#import "CPDataEvent.h"

@interface CPDataManager ()

@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation CPDataManager

NSString * const kPlistFileName = @"PhotosData";

+ (instancetype)sharedManager
{
    static id sharedObject;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        sharedObject = [[[self class] alloc] init];
        [sharedObject loadDataFromPlist];
    });
    return sharedObject;
}

- (void)loadDataFromPlist
{
    self.events = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:kPlistFileName ofType:@"plist"];
    NSDictionary *plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *allKeys = [plistDictionary allKeys];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    allKeys = [allKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
    for (NSString *key in allKeys) {
        NSDictionary *eventDictionary = plistDictionary[key];
        CPDataEvent *event = [[CPDataEvent alloc] initWithDictionary:eventDictionary];
        [self.events addObject:event];
    }
}

- (NSArray *)allEvents
{
    return self.events;
}

@end
