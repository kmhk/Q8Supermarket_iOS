//
//  AppDelegate.h
//  SuperMarket
//
//  Created by phoenix on 10/30/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;

+ (AppDelegate *)sharedInstance;
- (NSString *) storyName;
@end
