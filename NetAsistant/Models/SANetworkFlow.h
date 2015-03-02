//
//  SANetworkFlow.h
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SANetworkFlow : NSObject

@property (nonatomic, readonly) int64_t allFlow;
@property (nonatomic, readonly) int64_t allInFlow;
@property (nonatomic, readonly) int64_t allOutFlow;
@property (nonatomic, readonly) int64_t wifiFlow;
@property (nonatomic, readonly) int64_t wifiInFlow;
@property (nonatomic, readonly) int64_t wifiOutFlow;
@property (nonatomic, readonly) int64_t wwanFlow;
@property (nonatomic, readonly) int64_t wwanInFlow;
@property (nonatomic, readonly) int64_t wwanOutFlow;

- (instancetype)initWithAllFlow:(int64_t)allFlow allInFlow:(int64_t)allInFlow allOutFlow:(int64_t)allOutFlow wifiFlow:(int64_t)wifiFlow wifiInFlow:(int64_t)wifiInFlow wifiOutFlow:(int64_t)wifiOutFlow wwanFlow:(int64_t)wwanFlow wwanInFlow:(int64_t)wwanInFlow wwanOutFlow:(int64_t)wwanOutFlow;

@end
