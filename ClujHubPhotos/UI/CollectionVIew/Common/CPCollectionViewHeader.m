//
//  CPCollectionViewHeader.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/25/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPCollectionViewHeader.h"

@interface CPCollectionViewHeader ()

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *dateLabel;

@end

@implementation CPCollectionViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self addSubview:self.dateLabel];
    [self addSubview:self.nameLabel];
    self.backgroundColor = [UIColor colorWithRed:228.0 / 255.0
                                           green:228.0 / 255.0
                                            blue:228.0 / 255.0
                                           alpha:0.9];
    return self;
}

- (void)layoutSubviews
{
    CGFloat space = 5.0;
    CGFloat middleViewOnX = self.bounds.size.width / 2.0 - space;
    CGFloat middleViewOnY = self.bounds.size.height / 2.0;
    
    
    CGRect nameLabelFrame = self.nameLabel.frame;
    nameLabelFrame.origin.x = space;
    nameLabelFrame.origin.y = middleViewOnY - nameLabelFrame.size.height / 2.0;
    nameLabelFrame.size.width = middleViewOnX;
    self.nameLabel.frame = nameLabelFrame;
    
    CGRect dateLabelFrame = self.dateLabel.frame;
    dateLabelFrame.origin.y = middleViewOnY - dateLabelFrame.size.height / 2.0;
    dateLabelFrame.origin.x = middleViewOnX;
    dateLabelFrame.size.width = middleViewOnX - space;
    self.dateLabel.frame = dateLabelFrame;
}

#pragma mark properties

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
}

- (void)setDate:(NSDate *)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd"];
    NSString *dayString = [dateFormater stringFromDate:date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSUInteger monthIndex = components.month - 1;
    NSString *monthString = [dateFormater shortMonthSymbols][monthIndex];
    
    NSString *yearString = nil;
    NSInteger dateYear = components.year;
    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentYear = currentDateComponents.year;
    if (dateYear != currentYear) {
        yearString = [NSString stringWithFormat:@"%ld", (long)dateYear];
    }

    NSString *dateString;
    if (yearString) {
        dateString = [NSString stringWithFormat:@"%@ %@ %@", monthString, dayString, yearString];
    } else {
        dateString = [NSString stringWithFormat:@"%@ %@", monthString, dayString];
    }
    self.dateLabel.text = dateString;
    [self.dateLabel sizeToFit];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:12.0];
        _nameLabel.font = font;
    }
    return _nameLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        UIFont *font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
        _dateLabel.font = font;

    }
    return _dateLabel;
}


@end
