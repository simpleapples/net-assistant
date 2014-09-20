//
//  NetworkFlow.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "NetworkFlow.h"

@interface NetworkFlow ()

@property (nonatomic) NSInteger allFlow;
@property (nonatomic) NSInteger allInFlow;
@property (nonatomic) NSInteger allOutFlow;
@property (nonatomic) NSInteger wifiFlow;
@property (nonatomic) NSInteger wifiInFlow;
@property (nonatomic) NSInteger wifiOutFlow;
@property (nonatomic) NSInteger wwanFlow;
@property (nonatomic) NSInteger wwanInFlow;
@property (nonatomic) NSInteger wwanOutFlow;

@end

@implementation NetworkFlow

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use initWithAllFlow:allInFlow:allOutFlow:wifiFlow:wifiInFlow:wifiOutFlow:wwanFlow:wwanInFlow:wwanOutFlow: instead." userInfo:nil];
}

- (instancetype)initWithAllFlow:(NSInteger)allFlow allInFlow:(NSInteger)allInFlow allOutFlow:(NSInteger)allOutFlow wifiFlow:(NSInteger)wifiFlow wifiInFlow:(NSInteger)wifiInFlow wifiOutFlow:(NSInteger)wifiOutFlow wwanFlow:(NSInteger)wwanFlow wwanInFlow:(NSInteger)wwanInFlow wwanOutFlow:(NSInteger)wwanOutFlow
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
