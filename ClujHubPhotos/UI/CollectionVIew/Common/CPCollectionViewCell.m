//
//  CPCollectionViewCell.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPCollectionViewCell.h"

@interface CPCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation CPCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark properties

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.borderWidth = 3.0;
        _imageView.clipsToBounds = TRUE;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

@end
