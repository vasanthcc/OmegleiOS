//
//  AppDelegate.m
//  AutoOmegle
//
//  Created by Vasanth Ravichandran on 12/08/14.
//  Copyright (c) 2014 cc. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatHomeViewController.h"
#import "MainViewController.h"
#import "CCWindow.h"
#import "AppData.h"
@interface AppDelegate()
{
    
}
@property  MainViewController *mainNavigationController;
@end
@implementation AppDelegate
@synthesize mainNavigationController,applicationWindow;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.applicationWindow = [[CCWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.applicationWindow makeKeyAndVisible];
    
    //[self setupGoogleAnalytics];
    //[self setupParse];
    [self loadStaticDataFromDB];
    
    BaseViewController *homeViewController=[[ChatHomeViewController alloc] init];
    
    self.mainNavigationController = [[MainViewController alloc] initWithRootViewController:homeViewController];
    self.mainNavigationController.delegate = self.mainNavigationController;
    self.mainNavigationController.navigationBarHidden = YES;
    self.applicationWindow.rootViewController = mainNavigationController;
    
    return YES;
}
-(void)loadStaticDataFromDB
{
    [[AppData getAppData] synchAppDataWithUserDefaultOnEnter];
}
-(void)loadDBFromStaticData
{
    [[AppData getAppData] synchUserDefaultWithAppDataBeforeExit];
}
-(void)setupGoogleAnalytics
{
    //    [GAI sharedInstance].trackUncaughtExceptions = YES;
    //
    //    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    //
    //    [GAI sharedInstance].dispatchInterval = 20;
    //
    //    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-XXXXXXX-Y"];
    
    //    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    //    [tracker set:kGAIScreenName value:@"Stopwatch"];
    //    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}
-(void)setupParse
{
//    [Parse setApplicationId:@"parseAppId" clientKey:@"parseClientKey"];
//    [PFFacebookUtils initializeFacebook];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self loadDBFromStaticData];
    
    //Enable the idle timer
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [FBAppCall handleOpenURL:url
//                  sourceApplication:sourceApplication
//                        withSession:[PFFacebookUtils session]];
//}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
