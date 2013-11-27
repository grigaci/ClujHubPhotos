//
//  CPEventsViewController.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPEventsViewController.h"
#import "CPDataEvent.h"
#import "CPDataManager.h"
#import "CPCollectionViewCell.h"
#import "CPPhotoViewController.h"
#import "CPNoninteractiveTransition.h"
#import "CPCollectionViewHeader.h"
#import "CPCollectionViewData.h"

@interface CPEventsViewController ()

@property (nonatomic, strong) CPPhotoViewController *photoViewController;
@property (nonatomic, strong) CPNoninteractiveTransition *noninteractiveTransition;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGesture;

@end

@implementation CPEventsViewController

static NSString * const kCPEventsViewControllerTitle = @"Photos";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = kCPEventsViewControllerTitle;
    [self addRightBarButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.collectionView addGestureRecognizer:self.screenEdgePanGesture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.collectionView removeGestureRecognizer:self.screenEdgePanGesture];
}

- (void)addRightBarButton
{
    const CGFloat buttonWidth = 30.0;
    const CGFloat buttonHeight = 30.0;
    CGRect frame = CGRectMake(0.0, 0.0, buttonWidth, buttonHeight);
    UIView *customView = [[UIView alloc] initWithFrame:frame];

    UIImage *settingsIcon = [UIImage imageNamed:@"settings"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setImage:settingsIcon forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}

#pragma mark handle events

- (void)rightBarButtonPressed:(id)sender
{
    [self.delegate pushSettingsScreen];
}

- (void)handlePanGesture:(UIScreenEdgePanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            [self handlePanGestureBegan:panGesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self handlePanGestureChanged:panGesture];
            break;
        case UIGestureRecognizerStateEnded:
            [self handlePanGestureEnded:panGesture];
            break;
        case UIGestureRecognizerStateCancelled:
            [self handlePanGesturCancelled:panGesture];
            break;
        default:
            break;
    }
}

- (void)handlePanGestureBegan:(UIPanGestureRecognizer *)panGesture
{
    [self.delegate startTransitionFromEvents];
}

- (void)handlePanGestureChanged:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = [panGesture locationInView:self.collectionView];
    CGFloat ratio = ABS(1.0 - location.x / CGRectGetWidth(self.collectionView.bounds));
    [self.delegate updateTranstionFromEvents:ratio];
}

- (void)handlePanGestureEnded:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = [panGesture locationInView:self.collectionView];
    CGFloat middleScreenOnX = self.collectionView.bounds.size.width / 2.0;
    BOOL shouldFinishTransition = location.x <  middleScreenOnX;
    if (shouldFinishTransition) {
        [self.delegate finishTranstionFromEvents];
    }
    else {
        [self.delegate cancelTransitionFromEvents];
    }
}

- (void)handlePanGesturCancelled:(UIPanGestureRecognizer *)panGesture
{
   [self.delegate cancelTransitionFromEvents];
}

#pragma mark UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allEvent = [[CPDataManager sharedManager] allEvents];
    if (indexPath.section >= [allEvent count]) {
        return;
    }
    CPDataEvent *event = allEvent[indexPath.section];
    UIImage *image = [event photoAtIndex:indexPath.row];
    self.photoViewController.image = image;
    [self presentViewController:self.photoViewController animated:YES completion:nil];
}

#pragma mark properties

- (void)setCustomDataSource:(id<UICollectionViewDataSource>)customDataSource
{
    if (![_customDataSource isEqual:customDataSource]) {
        _customDataSource = customDataSource;
        self.collectionView.dataSource = _customDataSource;
    }
}

- (CPPhotoViewController *)photoViewController
{
    if (!_photoViewController) {
        _photoViewController = [[CPPhotoViewController alloc] initWithNibName:nil bundle:nil];
        _photoViewController.modalPresentationStyle = UIModalPresentationCustom;
        _photoViewController.transitioningDelegate = self.noninteractiveTransition;
    }
    return _photoViewController;
}

- (CPNoninteractiveTransition *)noninteractiveTransition
{
    if (!_noninteractiveTransition) {
        _noninteractiveTransition = [[CPNoninteractiveTransition alloc] init];
    }
    return _noninteractiveTransition;
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGesture
{
    if (!_screenEdgePanGesture) {
        _screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handlePanGesture:)];
        _screenEdgePanGesture.edges = UIRectEdgeRight;
    }
    return _screenEdgePanGesture;
}

@end
