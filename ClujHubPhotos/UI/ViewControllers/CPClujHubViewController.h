//
//  CPClujHubViewController.h
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 11/6/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

@import UIKit;

@protocol CPClujHubViewControllerDelegate <NSObject>

- (void)pushNextScreenFromClujHub;
- (void)startTransitionFromClujHub;
- (void)updateTranstionFromClujHub:(CGFloat)progress;
- (void)finishTranstionFromClujHub;
- (void)cancelTransitionFromClujHub;

@end


@interface CPClujHubViewController : UICollectionViewController

@property (nonatomic, weak) id<UICollectionViewDataSource> customDataSource;
@property (nonatomic, weak) id<CPClujHubViewControllerDelegate> delegate;

@end
