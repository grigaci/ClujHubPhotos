//
//  CPNoninteractiveTransition.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/23/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPNoninteractiveTransition.h"


typedef NS_ENUM(NSInteger, CPNoninteractiveTransitionMode){
    CPNoninteractiveTransitionModePresent = 0,
    CPNoninteractiveTransitionModeDismiss
};


@interface CPNoninteractiveTransition ()

@property (nonatomic, assign) CPNoninteractiveTransitionMode mode;
@property (nonatomic, readonly, assign) NSTimeInterval totalDuration;
@property (nonatomic, readonly, assign) CGFloat bounceLengthOnY;

@end

@implementation CPNoninteractiveTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mode = CPNoninteractiveTransitionModePresent;
        _totalDuration = .7;
        _bounceLengthOnY = 100.0;
    }
    return self;
}

#pragma mark UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.mode = CPNoninteractiveTransitionModePresent;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.mode = CPNoninteractiveTransitionModeDismiss;
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning methods

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get view controllers to be animated.
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;

    // Call the appropriate animation method.
    switch (self.mode) {
        case CPNoninteractiveTransitionModePresent:
            [self slideInAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
            break;
        case CPNoninteractiveTransitionModeDismiss:
            [self slideOutAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
            break;
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.totalDuration;
}

#pragma mark private methods

-(void)slideInAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
                 fromVC:(UIViewController *)fromVC
                   toVC:(UIViewController *)toVC
               fromView:(UIView *)fromView
                 toView:(UIView *)toView
{
    const NSTimeInterval firstStepDuration = 0.5;
    const NSTimeInterval secondStepDuration = 0.2;

    UIView *containerView = [transitionContext containerView];
    CGRect containerViewFrame = containerView.frame;

    // Add toView into containerView.
    CGRect offScreenFrame = containerView.frame;
    offScreenFrame.origin.y = containerView.frame.size.height;
    toView.frame = offScreenFrame;
    [containerView insertSubview:toView aboveSubview:fromView];

    // Do slide in animation
    [UIView animateKeyframesWithDuration:self.totalDuration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  // 1st animation step
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:firstStepDuration animations:^{
                                      toView.frame = CGRectOffset(containerViewFrame, 0.0, -self.bounceLengthOnY);
                                  }];
                                  // 2nd animation step
                                  [UIView addKeyframeWithRelativeStartTime:firstStepDuration relativeDuration:secondStepDuration animations:^{
                                      toView.frame = containerViewFrame;
                                  }];

                              } completion:^(BOOL finished) {
                                  [transitionContext completeTransition:YES];
                              }
     ];
}

-(void)slideOutAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
                  fromVC:(UIViewController *)fromVC
                    toVC:(UIViewController *)toVC
                fromView:(UIView *)fromView
                  toView:(UIView *)toView
{

    const NSTimeInterval firstStepDuration = 0.2;
    const NSTimeInterval secondStepDuration = 0.5;

    UIView* containerView = [transitionContext containerView];
    CGRect containerViewFrame = containerView.frame;

    // Add toView into containerView.
    [containerView insertSubview:toView belowSubview:fromView];

    [UIView animateKeyframesWithDuration:self.totalDuration
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  // 1st animation step
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:firstStepDuration animations:^{
                                      fromView.frame = CGRectOffset(containerView.frame, 0.0, self.bounceLengthOnY);
                                  }];
                                  // 2nd animation step
                                  [UIView addKeyframeWithRelativeStartTime:firstStepDuration relativeDuration:secondStepDuration animations:^{
                                      fromView.frame = CGRectOffset(containerViewFrame, 0.0, -CGRectGetHeight(containerViewFrame));
                                  }];
                              } completion:^(BOOL finished) {
                                  [transitionContext completeTransition:YES];
                              }
     ];
}

@end
