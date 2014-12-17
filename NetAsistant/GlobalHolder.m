//
//  GlobalHolder.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "GlobalHolder.h"

@interface GlobalHolder ()

@property (strong, nonatomic) NSArray *colorArray;

@end

@implementation GlobalHolder

+ (GlobalHolder *)sharedSingleton
{
    static GlobalHolder *sharedSingleton;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        if (!sharedSingleton) {
            sharedSingleton = [[GlobalHolder alloc] init];
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
    }
    return self;
}

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

- (void)backupToFile
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.netasistant"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.limitFlow] forKey:@"limitFlow"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.lastFlow] forKey:@"lastFlow"];
    [userDefaults setObject:[NSNumber numberWithLongLong:self.offsetFlow] forKey:@"offsetFlow"];
    [userDefaults setObject:self.lastDate forKey:@"lastDate"];
    [userDefaults synchronize];
}

- (void)recoverFromFile
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.netasistant"];
    self.limitFlow = [[userDefaults objectForKey:@"limitFlow"] longLongValue];
    self.limitFlow = [[userDefaults objectForKey:@"limitFlow"] longLongValue];
    self.lastFlow = [[userDefaults objectForKey:@"lastFlow"] longLongValue];
    self.offsetFlow = [[userDefaults objectForKey:@"offsetFlow"] longLongValue];
    self.lastDate = [userDefaults objectForKey:@"lastDate"];
}

@end
