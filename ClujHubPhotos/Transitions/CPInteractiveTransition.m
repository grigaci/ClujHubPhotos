//
//  CPInteractiveTransition.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPInteractiveTransition.h"

@interface CPInteractiveTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readonly, assign) NSTimeInterval totalDuration;

@end


@implementation CPInteractiveTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        _totalDuration = 0.5;
    }
    return self;
}

#pragma mark UIViewControllerTransitioningDelegate methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
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
    // Notify UIPercentDrivenInteractiveTransition.
    [super startInteractiveTransition:transitionContext];

    // Get objects from context
    self.transitionContext = transitionContext;
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *toView = toVC.view;

    // Add view into containerView
    CGRect toViewFrame = containerView.bounds;
    toViewFrame.origin.x = CGRectGetWidth([[transitionContext containerView] bounds]);
    toView.frame = toViewFrame;
    [containerView addSubview:toView];
}

#pragma mark - UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{

    // Notify UIPercentDrivenInteractiveTransition.
    [super updateInteractiveTransition:percentComplete];

    // Get objects from context
    UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [self.transitionContext containerView];
    UIView *toView = toVC.view;

    // Reposition toView in containerView.
    CGFloat screenWidth = CGRectGetWidth(containerView.bounds);
    CGFloat widthToRemove = screenWidth * percentComplete;
    CGFloat totalWidth = screenWidth - widthToRemove;
    CGRect frame = toView.frame;
    frame.origin.x = totalWidth;
    toView.frame = frame;
}

- (void)finishInteractiveTransition
{
    // Notify UIPercentDrivenInteractiveTransition.
    [super finishInteractiveTransition];
    
    // Get objects from context
    UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [self.transitionContext containerView];
    UIView *toView = toVC.view;

    [UIView animateWithDuration:self.duration animations:^{
        toView.frame = containerView.bounds;
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:YES];
    }];
}

- (void)cancelInteractiveTransition {
    // Notify UIPercentDrivenInteractiveTransition.
    [super cancelInteractiveTransition];
    
    // Get objects from context
    UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [self.transitionContext containerView];
    UIView *toView = toVC.view;

    CGRect toViewEndFrame = CGRectOffset(containerView.bounds, CGRectGetWidth(containerView.bounds), 0);

    [UIView animateWithDuration:self.totalDuration animations:^{
        toView.frame = toViewEndFrame;
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:NO];
    }];
}

@end
