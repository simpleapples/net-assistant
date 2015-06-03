//
//  GlobalHolder.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "SAGlobalHolder.h"
#import "SANetworkFlow.h"
#import "SACoreDataManager.h"
#import "SAConvertUtils.h"

@interface SAGlobalHolder ()

@property (nonatomic, readwrite) int64_t packageFlow;
@property (nonatomic, readwrite) int64_t usedFlow;
@property (nonatomic, readwrite) int64_t remainedFlow;
@property (nonatomic, readwrite) int64_t lastRecordFlow;
@property (strong, nonatomic, readwrite) NSDate *lastRecordDate;
@property (strong, nonatomic) NSArray *colorArray;

@end

@implementation SAGlobalHolder

+ (SAGlobalHolder *)sharedSingleton
{
    static SAGlobalHolder *sharedSingleton;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        if (!sharedSingleton) {
            sharedSingleton = [[SAGlobalHolder alloc] init];
        }
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIColor *yellow = [UIColor colorWithRed:252 / 255.0f green:176 / 255.0f blue:60 / 255.0f alpha:1.0f];
        UIColor *red = [UIColor colorWithRed:252 / 255.0f green:91 / 255.0f blue:63 / 255.0f alpha:1.0f];
        UIColor *green = [UIColor colorWithRed:79 / 255.0f green:202 / 255.0f blue:82 / 255.0f alpha:1.0f];
        self.colorArray = [[NSArray alloc] initWithObjects:green, yellow, red, nil];
        [self recoverFromFile];
    }
    return self;
}

- (void)updateDataWithNetworkFlow:(SANetworkFlow *)networkFlow
{
    int64_t increasedFlow = 0;
    if (networkFlow.wwanFlow >= self.lastRecordFlow) {
        increasedFlow = networkFlow.wwanFlow - self.lastRecordFlow;
        self.usedFlow = increasedFlow + self.usedFlow;
    }
    NSDate *nowDate = [NSDate date];
    [[SACoreDataManager manager] insertOrUpdateDetailWithFlowValue:increasedFlow date:nowDate];
    self.remainedFlow = self.packageFlow - self.usedFlow;
    self.lastRecordFlow = networkFlow.wwanFlow;
    self.lastRecordDate = nowDate;
}

- (void)updatePackageFlow:(int64_t)packageFlow
{
    self.packageFlow = packageFlow;
}

- (void)calibrateUsedFlow:(int64_t)usedFlow
{
    self.usedFlow = usedFlow;
    self.lastRecordDate = [NSDate date];
}

- (void)cleanFlowOfLastMonth
{
    self.usedFlow = 0;
    self.lastRecordDate = [NSDate date];
}

#pragma mark - Color

- (UIColor *)colorWithType:(COLOR_TYPE)type
{
    switch (type) {
        case COLOR_TYPE_NORMAL:
            return [self.colorArray objectAtIndex:0];
        case COLOR_TYPE_WARNNING:
            return [self.colorArray objectAtIndex:1];
        case COLOR_TYPE_ERROR:
            return [self.colorArray objectAtIndex:2];
    }
}

- (UIColor *)colorWithPercent:(NSInteger)percent
{
    if (percent < 10) {
        return [self colorWithType:COLOR_TYPE_ERROR];
    } else if (percent < 20) {
        return [self colorWithType:COLOR_TYPE_WARNNING];
    }
    return [self colorWithType:COLOR_TYPE_NORMAL];
}

#pragma mark - UserDefaults

- (void)backupToFile
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.netasistant"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.packageFlow] forKey:@"limitFlow"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.usedFlow] forKey:@"offsetFlow"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.remainedFlow] forKey:@"remainedFlow"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.lastRecordFlow] forKey:@"lastFlow"];
    [userDefaults setObject:self.lastRecordDate forKey:@"lastDate"];
    [userDefaults synchronize];
}

- (void)recoverFromFile
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.netasistant"];
    self.packageFlow = [[userDefaults objectForKey:@"limitFlow"] longLongValue];
    self.usedFlow = [[userDefaults objectForKey:@"offsetFlow"] longLongValue];
    self.remainedFlow = [[userDefaults objectForKey:@"remainedFlow"] longLongValue];
    self.lastRecordFlow = [[userDefaults objectForKey:@"lastFlow"] longLongValue];
    self.lastRecordDate = [userDefaults objectForKey:@"lastDate"];
}

@end
