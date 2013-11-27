//
//  CPNavigationController.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPNavigationController.h"
#import "CPEventsViewController.h"
#import "CPEventsCollectionViewLayout.h"
#import "CPSettingsViewController.h"
#import "CPInteractiveTransition.h"
#import "CPClujHubViewController.h"
#import "CPClujHubCollectionViewLayout.h"
#import "CPCollectionViewData.h"
#import "CPCollectionViewTransition.h"

typedef NS_ENUM(NSUInteger, CPTransition)
{
    CPTransitionSettingsVC = 0,
    CPTransitionEventsVC,
    CPTransitionDefault
};

@interface CPNavigationController () <UINavigationControllerDelegate, CPEventsViewControllerDelegate, CPClujHubViewControllerDelegate>

@property (nonatomic, strong) CPEventsCollectionViewLayout *eventsCollectionViewLayout;
@property (nonatomic, strong) CPEventsViewController *eventsCollectionViewController;

@property (nonatomic, strong) CPSettingsViewController *settingsViewController;

@property (nonatomic, strong) CPInteractiveTransition *customInteractiveTransition;
@property (nonatomic, strong) CPCollectionViewTransition *customCollectionViewTransition;

@property (nonatomic, strong) CPCollectionViewData *collectionViewData;

@property (nonatomic, strong) CPClujHubViewController *clujHubViewController;
@property (nonatomic, strong) CPClujHubCollectionViewLayout *clujHubLayout;

@property (nonatomic, assign) CPTransition customTransition;

@end

@implementation CPNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:self.clujHubViewController];
    if (self) {
        _customTransition = CPTransitionDefault;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    id<UIViewControllerInteractiveTransitioning> returnObject = nil;
    switch (self.customTransition) {
        case CPTransitionSettingsVC:
            returnObject = self.customInteractiveTransition;
            break;
        case CPTransitionEventsVC:
            returnObject = self.customCollectionViewTransition;
            break;
        default:
            break;
    }
    return returnObject;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    id<UIViewControllerAnimatedTransitioning> returnObject = nil;
    switch (self.customTransition) {
        case CPTransitionSettingsVC:
            returnObject = self.customInteractiveTransition;
            break;
        case CPTransitionEventsVC:
            returnObject = self.customCollectionViewTransition;
            break;
        default:
            break;
    }
    return returnObject;
}

#pragma mark CPEventsViewControllerDelegate method

- (void)pushSettingsScreen
{
    self.customTransition = CPTransitionDefault;
    self.delegate = nil;
    [self pushViewController:self.settingsViewController animated:YES];
}

- (void)startTransitionFromEvents
{
    self.customTransition = CPTransitionSettingsVC;
    self.delegate = self;
    [self pushViewController:self.settingsViewController animated:YES];
}

- (void)updateTranstionFromEvents:(CGFloat)progress
{
    [self.customInteractiveTransition updateInteractiveTransition:progress];
}

- (void)finishTranstionFromEvents
{
    [self.customInteractiveTransition finishInteractiveTransition];
    self.delegate = nil;
    self.customTransition = CPTransitionDefault;
}

- (void)cancelTransitionFromEvents
{
    [self.customInteractiveTransition cancelInteractiveTransition];
    self.delegate = nil;
    self.customTransition = CPTransitionDefault;
}

#pragma mark CPClujHubViewControllerDelegate method

- (void)pushNextScreenFromClujHub
{
    [self pushViewController:self.eventsCollectionViewController animated:YES];
}

- (void)startTransitionFromClujHub
{
    self.customTransition = CPTransitionEventsVC;
    self.delegate = self;
    [self pushViewController:self.eventsCollectionViewController animated:YES];
}

- (void)updateTranstionFromClujHub:(CGFloat)progress
{
    [self.customCollectionViewTransition updateInteractiveTransition:progress];
}

- (void)finishTranstionFromClujHub
{
    [self.clujHubViewController.collectionView finishInteractiveTransition];
    [self.customCollectionViewTransition finishInteractiveTransition];
    self.delegate = nil;
    self.customTransition = CPTransitionDefault;
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:2];
}

- (void)reloadData
{
    [self.eventsCollectionViewController.collectionView reloadData];
}

- (void)cancelTransitionFromClujHub
{
    [self.clujHubViewController.collectionView finishInteractiveTransition];
    [self.customCollectionViewTransition cancelInteractiveTransition];
    self.delegate = nil;
    self.customTransition = CPTransitionDefault;
}

#pragma mark properties

- (CPEventsCollectionViewLayout *)eventsCollectionViewLayout
{
    if (!_eventsCollectionViewLayout) {
        _eventsCollectionViewLayout = [[CPEventsCollectionViewLayout alloc] init];
    }
    return _eventsCollectionViewLayout;
}

- (CPEventsViewController *)eventsCollectionViewController
{
    if (!_eventsCollectionViewController) {
        _eventsCollectionViewController = [[CPEventsViewController alloc] initWithCollectionViewLayout:self.eventsCollectionViewLayout];
        _eventsCollectionViewController.delegate = self;
        _eventsCollectionViewController.customDataSource = self.collectionViewData;
        _eventsCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    }
    return _eventsCollectionViewController;
}

- (CPSettingsViewController *)settingsViewController
{
    if (!_settingsViewController) {
        _settingsViewController = [[CPSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _settingsViewController;
}

- (CPInteractiveTransition *)customInteractiveTransition
{
    if (!_customInteractiveTransition) {
        _customInteractiveTransition = [[CPInteractiveTransition alloc] init];
    }
    return _customInteractiveTransition;
}

- (CPCollectionViewData *)collectionViewData
{
    if (!_collectionViewData) {
        _collectionViewData = [[CPCollectionViewData alloc] init];
    }
    return _collectionViewData;
}

- (CPClujHubViewController *)clujHubViewController
{
    if (!_clujHubViewController) {
        _clujHubViewController = [[CPClujHubViewController alloc] initWithCollectionViewLayout:self.clujHubLayout];
        _clujHubViewController.customDataSource = self.collectionViewData;
        _clujHubViewController.delegate = self;
    }
    return _clujHubViewController;
}

- (CPClujHubCollectionViewLayout *)clujHubLayout
{
    if (!_clujHubLayout) {
        _clujHubLayout = [[CPClujHubCollectionViewLayout alloc] init];
    }
    return _clujHubLayout;
}

- (CPCollectionViewTransition *)customCollectionViewTransition
{
    if (!_customCollectionViewTransition) {
        _customCollectionViewTransition = [[CPCollectionViewTransition alloc] init];
    }
    return _customCollectionViewTransition;
}

@end
