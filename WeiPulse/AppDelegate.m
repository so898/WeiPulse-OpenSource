//
//  AppDelegate.m
//  WeiFaTest2
//
//  Created by Bill Cheng on 12-6-26.
//  Copyright (c) 2012年 R3 Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Version"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:VERSION] forKey:@"Version"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Font"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"TimeStamp"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"ShowFace"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"NoticeSound"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"WebReader"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"StorePhoto"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"ShareWeb"];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Version"] floatValue] != VERSION){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:VERSION] forKey:@"Version"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Font"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"TimeStamp"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"ShowFace"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"NoticeSound"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"WebReader"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"StorePhoto"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"ShareWeb"];
    }
    
    
    
    self.window.rootViewController = [RootViewController new];
    slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    HomeViewController *a =[HomeViewController getInstance];
    slidingViewController.topViewController = a;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    return YES;
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UIViewController *a= slidingViewController.topViewController;
    if ([a respondsToSelector:@selector(appWillClose)]) {
        [a performSelector:@selector(appWillClose)];
    }
}

@end
