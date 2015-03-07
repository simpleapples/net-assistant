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
    SANetworkFlow *networkFlow = [SANetworkFlowService networkFlow];
    int64_t usedFlow = 0;
    if (networkFlow.wwanFlow >= [SAGlobalHolder sharedSingleton].lastUsedFlow) {
        usedFlow = networkFlow.wwanFlow - [SAGlobalHolder sharedSingleton].lastUsedFlow + [SAGlobalHolder sharedSingleton].usedFlow;
    } else {
        usedFlow = [SAGlobalHolder sharedSingleton].usedFlow;
    }
    [SAGlobalHolder sharedSingleton].lastUsedFlow = networkFlow.wwanFlow;
    [SAGlobalHolder sharedSingleton].usedFlow = usedFlow;
    [SAGlobalHolder sharedSingleton].lastRecordDate = [NSDate date];
    [[SAGlobalHolder sharedSingleton] backupToFile];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
