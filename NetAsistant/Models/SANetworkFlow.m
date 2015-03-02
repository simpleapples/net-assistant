//
//  SANetworkFlow.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "SANetworkFlow.h"

@interface SANetworkFlow ()

@property (nonatomic) int64_t allFlow;
@property (nonatomic) int64_t allInFlow;
@property (nonatomic) int64_t allOutFlow;
@property (nonatomic) int64_t wifiFlow;
@property (nonatomic) int64_t wifiInFlow;
@property (nonatomic) int64_t wifiOutFlow;
@property (nonatomic) int64_t wwanFlow;
@property (nonatomic) int64_t wwanInFlow;
@property (nonatomic) int64_t wwanOutFlow;

@end

@implementation SANetworkFlow

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithAllFlow:allInFlow:allOutFlow:wifiFlow:wifiInFlow:wifiOutFlow:wwanFlow:wwanInFlow:wwanOutFlow: instead." userInfo:nil];
}

- (instancetype)initWithAllFlow:(int64_t)allFlow allInFlow:(int64_t)allInFlow allOutFlow:(int64_t)allOutFlow wifiFlow:(int64_t)wifiFlow wifiInFlow:(int64_t)wifiInFlow wifiOutFlow:(int64_t)wifiOutFlow wwanFlow:(int64_t)wwanFlow wwanInFlow:(int64_t)wwanInFlow wwanOutFlow:(int64_t)wwanOutFlow
{
    self = [super init];
    if (self) {
        self.allFlow = allFlow;
        self.allInFlow = allInFlow;
        self.allOutFlow = allOutFlow;
        self.wifiFlow = wifiFlow;
        self.wifiInFlow = wifiInFlow;
        self.wifiOutFlow = wifiOutFlow;
        self.wwanFlow = wwanFlow;
        self.wwanInFlow = wwanInFlow;
        self.wwanOutFlow = wwanOutFlow;
    }
    return self;
}

@end
