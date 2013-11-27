//
//  CPClujHubViewController.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 11/6/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPClujHubViewController.h"
#import "CPCollectionViewCell.h"
#import "CPCollectionViewHeader.h"
#import "CPCollectionViewData.h"

@interface CPClujHubViewController ()

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, assign) CGPoint initialPoint;
@property (nonatomic, assign) CGFloat initialDistance;

@end

@implementation CPClujHubViewController

static NSString * const kCPClujHubViewControllerTitle = @"Cluj Hub";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kCPClujHubViewControllerTitle;

    [self.collectionView registerClass:[CPCollectionViewCell class] forCellWithReuseIdentifier:kCPCollectionViewCell];
    [self.collectionView registerClass:[CPCollectionViewHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kCPCollectionViewHeader];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.collectionView addGestureRecognizer:self.pinchGesture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.collectionView removeGestureRecognizer:self.pinchGesture];
}

#pragma mark gesture methods

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self handlePinchGestureBegan:pinchGesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self handlePinchGestureChanged:pinchGesture];
            break;
        case UIGestureRecognizerStateEnded:
            [self handlePinchGestureEnded:pinchGesture];
            break;
        case UIGestureRecognizerStateCancelled:
            [self handlePinchGestureFailed:pinchGesture];
            break;
        default:
            break;
    }
}

- (void)handlePinchGestureBegan:(UIPinchGestureRecognizer *)pinchGesture
{
    if ([pinchGesture numberOfTouches] < 2) {
        return;
    }
    
    CGPoint point1 = [pinchGesture locationOfTouch:0 inView:self.collectionView];
    CGPoint point2 = [pinchGesture locationOfTouch:1 inView:self.collectionView];
    CGFloat distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    CGPoint point = [pinchGesture locationInView:self.collectionView];

    self.initialPoint = point;
    self.initialDistance = distance;
    [self.delegate startTransitionFromClujHub];
}

- (void)handlePinchGestureChanged:(UIPinchGestureRecognizer *)pinchGesture
{
    if ([pinchGesture numberOfTouches] < 2) {
        return;
    }

    // Calculate progress according to distance between the two touch points.
    CGPoint point1 = [pinchGesture locationOfTouch:0 inView:self.collectionView];
    CGPoint point2 = [pinchGesture locationOfTouch:1 inView:self.collectionView];
    CGFloat distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    CGFloat distanceDelta = distance - self.initialDistance;
    CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width +
                             self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
    CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);

    [self.delegate updateTranstionFromClujHub:progress];
}

- (void)handlePinchGestureEnded:(UIPinchGestureRecognizer *)pinchGesture
{
    [self.delegate finishTranstionFromClujHub];
}

- (void)handlePinchGestureFailed:(UIPinchGestureRecognizer *)pinchGesture
{
    [self.delegate cancelTransitionFromClujHub];
}

#pragma mark properties

- (void)setCustomDataSource:(id<UICollectionViewDataSource>)customDataSource
{
    if (![_customDataSource isEqual:customDataSource]) {
        _customDataSource = customDataSource;
        self.collectionView.dataSource = _customDataSource;
    }
}

- (UIPinchGestureRecognizer *)pinchGesture
{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(handlePinchGesture:)];
    }
    return _pinchGesture;
}

#pragma mark UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate pushNextScreenFromClujHub];
}

@end
