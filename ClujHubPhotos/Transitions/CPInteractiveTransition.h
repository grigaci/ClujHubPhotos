//
//  CPInteractiveTransition.h
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

@import UIKit;

@interface CPInteractiveTransition : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate,
                                                                           UIViewControllerAnimatedTransitioning>

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)finishInteractiveTransition;
- (void)cancelInteractiveTransition;

@end
