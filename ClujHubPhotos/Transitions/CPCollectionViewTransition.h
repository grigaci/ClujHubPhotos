//
//  CPCollectionViewTransition.h
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 11/12/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

@import Foundation;

@interface CPCollectionViewTransition : NSObject <UIViewControllerAnimatedTransitioning,
                                                  UIViewControllerInteractiveTransitioning>

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)finishInteractiveTransition;
- (void)cancelInteractiveTransition;

@end
