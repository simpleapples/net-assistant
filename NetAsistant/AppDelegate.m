//
//  AppDelegate.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "AppDelegate.h"
#import "SAGlobalHolder.h"
#import "SANetworkFlowService.h"
#import "SANetworkFlow.h"
#import "MobClick.h"
#import "SACoreDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarHidden = NO;
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [MobClick startWithAppkey:@"54f041e7fd98c5f4e80001b4"];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setEncryptEnabled:YES];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
    SANetworkFlow *networkFlow = [SANetworkFlowService networkFlow];
    if (networkFlow) {
        [holder updateDataWithNetworkFlow:networkFlow];
        [holder backupToFile];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[SAGlobalHolder sharedSingleton] backupToFile];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[SACoreDataManager manager] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SACoreDataManager manager] saveContext];
}

@end
