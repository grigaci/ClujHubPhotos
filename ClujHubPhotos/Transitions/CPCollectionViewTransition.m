//
//  CPCollectionViewTransition.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 11/12/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPCollectionViewTransition.h"

@interface CPCollectionViewTransition ()

@property (nonatomic, strong) UICollectionViewTransitionLayout *transitionLayout;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readonly, assign) NSTimeInterval totalDuration;

@end

@implementation CPCollectionViewTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        _totalDuration = 1;
    }
    return self;
}


#pragma mark UIViewControllerAnimatedTransitioning methods

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.totalDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // No action needed.
}

#pragma mark - UIViewControllerInteractiveTransitioning Methods

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get view controllers from context.
    self.transitionContext = transitionContext;
    UICollectionViewController* fromCollectionViewController = (UICollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController* toCollectionViewController   = (UICollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // Start transition.
    UICollectionViewTransitionLayout *transitionLayout =
    [fromCollectionViewController.collectionView startInteractiveTransitionToCollectionViewLayout:toCollectionViewController.collectionViewLayout
                                                  completion:^(BOOL completed, BOOL finish) {
                                                      [self.transitionContext.containerView addSubview:toCollectionViewController.view];
                                                      [self.transitionContext completeTransition:YES];
                                                      self.transitionLayout = nil;
                                                      self.transitionContext = nil;
                                                  }];
    self.transitionLayout = transitionLayout;
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    // Update layout progress.
    [self.transitionLayout setTransitionProgress:percentComplete];

    // Set the content offset to (0, 0).
    [self.transitionLayout updateValue:0 forAnimatedKey:@"offsetH"];
    [self.transitionLayout updateValue:0 forAnimatedKey:@"offsetV"];
    [self.transitionLayout  invalidateLayout];

    // Update transition context. In this example, the system will update the navigation bar transition.
    [self.transitionContext updateInteractiveTransition:percentComplete];
}

- (void)finishInteractiveTransition
{
    [self.transitionContext finishInteractiveTransition];
}

- (void)cancelInteractiveTransition {
    [self.transitionContext cancelInteractiveTransition];
}

@end
