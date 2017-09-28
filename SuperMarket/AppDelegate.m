//
//  AppDelegate.m
//  SuperMarket
//
//  Created by phoenix on 10/30/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "AppDelegate.h"
#import "Setting.h"
#import "PushActions.h"
@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSString *) storyName {
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    NSString *storyName = @"Main";
    if (ver_float >= 7.0) {
        storyName = @"Main-iOS7";
    }
    
    return storyName;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = PP_AUTORELEASE([[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]);
    
    
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    if (ver_float >= 7.0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        if (IS_IPHONE_5)
//            [self.window setFrame:CGRectMake(0, 20, 320, 548)];
//        else if (IS_IPHONE_4)
//            [self.window setFrame:CGRectMake(0, 20, 320, 460)];
    }
    //MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:[self storyName] bundle:nil];
    UIViewController *rootview = [mainstoryboard instantiateViewControllerWithIdentifier:@"FirstView"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootview];
    _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    
    _revealSideViewController.delegate = self;
    
    self.window.rootViewController = _revealSideViewController;
    
    PP_RELEASE(rootview);
    PP_RELEASE(nav);
    

     [self.window makeKeyAndVisible];
    
    // Let the device know we want to receive push notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
 
    return YES;
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   // [Setting sharedInstance].pushInfo = [userInfo objectForKey:@"aps"];
    NSDictionary *defaultAlert = [userInfo objectForKey:@"aps"];
    [Setting sharedInstance].pushDefaultAlertString = [defaultAlert objectForKey:@"alert"];
    NSLog(@"companies = %d", [Setting sharedInstance].arrayCompany.count);
    NSLog(@"measure = %d", [Setting sharedInstance].arrayMeasures.count);
    NSLog(@"areas = %d", [Setting sharedInstance].Areas.count);
    NSLog(@"maincategories = %d", [Setting sharedInstance].MainCategories.count);
    NSLog(@"subcategories = %d", [Setting sharedInstance].SubCategories.count);
    NSLog(@"cities = %d", [Setting sharedInstance].Cities.count);

    
    [Setting sharedInstance].pushInfo = [userInfo objectForKey:@"pushInfo"];
    NSLog(@"push : %@", userInfo);
    NSString *pushStr = [Setting sharedInstance].pushInfo;

    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *dic = [parser objectWithString:pushStr];

    PushActions *newAction = [[PushActions alloc]init];
    if ([[dic objectForKey:@"notificationID"]intValue] == 4){
        switch ([[dic objectForKey:@"ObjectType"]intValue]) {
            case 1:
            {
                [newAction pushCompany];
            }
                break;
            case 2:
            {
                [newAction pushBranch];
            }
                break;
            case 3:
            {
                [newAction pushMainCategory];
            }
                break;
            case 4:
            {
                [newAction pushSubCategory];
            }
                break;
            case 5:
            {
                [newAction pushCity];
            }
                break;
            case 6:
            {
                [newAction pushArea];
            }
                break;
            case 7:
            {
                [newAction pushMeasure];
            }
                break;
                
            default:
                break;
        }
    }
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushDid" object:self];
   
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* deviceTokenStr = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @"<>"]] stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", deviceTokenStr);
    [Setting sharedInstance].deviceTokenString = deviceTokenStr;
    NSString *firstTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"];
    if ([firstTime isKindOfClass:[NSNull class]] || firstTime == nil){
        [[Setting sharedInstance] registerDevice];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
