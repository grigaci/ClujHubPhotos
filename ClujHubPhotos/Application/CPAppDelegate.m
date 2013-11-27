//
//  AppDelegate.m
//  ClujHubPhotos
//
//  Created by Bogdan on 10/22/13.
//  Copyright (c) 2013 Bogdan. All rights reserved.
//

#import "CPAppDelegate.h"
#import "CPNavigationController.h"

@interface CPAppDelegate ()

@property (nonatomic, strong) CPNavigationController *navigationController;

@end

@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (CPNavigationController *)navigationController
{
    if (!_navigationController) {
        _navigationController = [[CPNavigationController alloc] initWithRootViewController:nil];
    }
    return _navigationController;
}

@end
