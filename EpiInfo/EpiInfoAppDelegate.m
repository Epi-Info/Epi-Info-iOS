//
//  EpiInfoAppDelegate.m
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//  Copyright (c) 2012 John Copeland. All rights reserved.
//

#import "EpiInfoAppDelegate.h"
#import "FormView.h"
#import "ImportCSV.h"
#import "SyncView.h"
@import BoxContentSDK;

@implementation EpiInfoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [BOXContentClient setClientID:@"ugy4lgruo9nju5zl3hhr4wq3e280minq" clientSecret:@"wgDzGDJzi9vZqWxTHVAUKzGR8Y013jYd"];

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
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url.pathExtension lowercaseString] isEqualToString:@"epiform"] || [[url.pathExtension lowercaseString] isEqualToString:@"xml"])
    {
        UIView *fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, 40)];
        UILabel *fakeNavBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, 40)];
        [fakeNavBar setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [fakeNavBarLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
        [fakeNavBarLabel setTextAlignment:NSTextAlignmentCenter];
        [fakeNavBarLabel setTextColor:[UIColor whiteColor]];
        [fakeNavBarLabel setText:@"Import Epi Info Form"];
        [fakeNavBar addSubview:fakeNavBarLabel];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] addSubview:fakeNavBar];
        FormView *newForm = [[FormView alloc] initWithFrame:CGRectMake(0, 60, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.height - 60.0) AndURL:url AndRootViewController:self.window.rootViewController AndFakeNavBar:fakeNavBar];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] addSubview:newForm];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] bringSubviewToFront:fakeNavBar];
    }
    else if ([[url.pathExtension lowercaseString] isEqualToString:@"csv"])
    {
        UIView *fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, 40)];
        UILabel *fakeNavBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, 40)];
        [fakeNavBar setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [fakeNavBarLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
        [fakeNavBarLabel setTextAlignment:NSTextAlignmentCenter];
        [fakeNavBarLabel setTextColor:[UIColor whiteColor]];
        [fakeNavBarLabel setText:@"Import CSV File"];
        [fakeNavBar addSubview:fakeNavBarLabel];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] addSubview:fakeNavBar];
        ImportCSV *newCSV = [[ImportCSV alloc] initWithFrame:CGRectMake(0, 60, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.height - 60.0) AndURL:url AndRootViewController:self.window.rootViewController AndFakeNavBar:fakeNavBar];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] addSubview:newCSV];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] bringSubviewToFront:fakeNavBar];
    }
    else if ([[url.pathExtension lowercaseString] isEqualToString:@"epi7"])
    {
        UIView *fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, 40)];
        UILabel *fakeNavBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, 40)];
        [fakeNavBar setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [fakeNavBarLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
        [fakeNavBarLabel setTextAlignment:NSTextAlignmentCenter];
        [fakeNavBarLabel setTextColor:[UIColor whiteColor]];
        [fakeNavBarLabel setText:@"Import Sync File"];
        [fakeNavBar addSubview:fakeNavBarLabel];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] addSubview:fakeNavBar];
        SyncView *newSync = [[SyncView alloc] initWithFrame:CGRectMake(0, 60, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.width, [[UIApplication sharedApplication].keyWindow.rootViewController view].frame.size.height - 60.0) AndURL:url AndRootViewController:self.window.rootViewController AndFakeNavBar:fakeNavBar];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] addSubview:newSync];
        [[[UIApplication sharedApplication].keyWindow.rootViewController view] bringSubviewToFront:fakeNavBar];
    }

    return YES;
}

@end
