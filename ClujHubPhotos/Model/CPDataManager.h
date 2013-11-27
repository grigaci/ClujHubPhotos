//
//  CPDataManager.h
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

@import Foundation;

@interface CPDataManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)allEvents;

@end
