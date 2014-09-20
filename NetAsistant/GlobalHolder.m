//
//  GlobalHolder.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "GlobalHolder.h"

@implementation GlobalHolder

+ (GlobalHolder *)sharedSingleton
{
    static GlobalHolder *sharedSingleton;
    @synchronized(self) {
        if (!sharedSingleton) {
            sharedSingleton = [[GlobalHolder alloc] init];
        }
        return sharedSingleton;
    }
}

- (instancetype)init
{
    self = [super init];
    return self;
}

@end
