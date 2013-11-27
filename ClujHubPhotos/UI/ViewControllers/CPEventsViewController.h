//
//  CPEventsViewController.h
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

@import UIKit;

@protocol CPEventsViewControllerDelegate <NSObject>

- (void)pushSettingsScreen;

- (void)startTransitionFromEvents;
- (void)updateTranstionFromEvents:(CGFloat)progress;
- (void)finishTranstionFromEvents;
- (void)cancelTransitionFromEvents;

@end

@interface CPEventsViewController : UICollectionViewController

@property (nonatomic, weak) id<CPEventsViewControllerDelegate> delegate;
@property (nonatomic, weak) id<UICollectionViewDataSource> customDataSource;


@end
