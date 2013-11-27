//
//  CPPhotoViewController.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/23/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPPhotoViewController.h"

@interface CPPhotoViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation CPPhotoViewController

static CGFloat const kCPDoneButtonHeight = 50.0;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:47.0 / 255.0
                                                green:47.0 / 255.0
                                                 blue:47.0 / 255.0
                                                alpha:1.0];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.doneButton];
}

- (void)viewDidLayoutSubviews
{

    CGRect doneButtonFrame = CGRectMake(0,
                                        self.view.bounds.size.height - kCPDoneButtonHeight,
                                        self.view.bounds.size.width,
                                        kCPDoneButtonHeight);
    self.doneButton.frame = doneButtonFrame;
    
    CGRect imageViewFrame = CGRectMake(0,
                                       0,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - kCPDoneButtonHeight);
    self.imageView.frame = imageViewFrame;
}

- (void)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark properties

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];

        [_doneButton addTarget:self
                        action:@selector(doneButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}


@end
