//
//  CPSettingsViewController.m
//  ClujHubPhotos
//
//  Created by Bogdan Iusco on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPSettingsViewController.h"

typedef NS_ENUM(NSInteger, CPSettingsOption){
    CPSettingsOptionFacebook = 0,
    CPSettingsOptionInstagram = 1,
    CPSettingsOptionFlickr = 2
};

@interface CPSettingsViewController ()

@end

@implementation CPSettingsViewController

static NSString * const kCPCellIdentifier = @"Cell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCPCellIdentifier];
    self.title = @"Settings";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCPCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCPCellIdentifier];
    }

    NSString *text;
    switch (indexPath.row) {
        case CPSettingsOptionFacebook:
            text = @"Facebook";
            break;
        case CPSettingsOptionInstagram:
            text = @"Instagram";
            break;
        case CPSettingsOptionFlickr:
            text = @"Flickr";
            break;
        default:
            text = @"Other";
            break;
    }
    cell.textLabel.text = text;
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.on = YES;
    cell.accessoryView = switchview;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Share";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Allow integration with social networks.";
}

@end
