//
//  CPDataEvent.h
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

@import Foundation;

@interface CPDataEvent : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSDate *date;

- (NSUInteger)countPhotos;
- (UIImage *)photoAtIndex:(NSUInteger)index;
- (UIImage *)thumbnailAtindex:(NSUInteger)index;

@end
