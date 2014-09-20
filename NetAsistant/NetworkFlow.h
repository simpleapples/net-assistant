//
//  NetworkFlow.h
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NetworkFlow : NSObject

@property (nonatomic, readonly) NSInteger allFlow;
@property (nonatomic, readonly) NSInteger allInFlow;
@property (nonatomic, readonly) NSInteger allOutFlow;
@property (nonatomic, readonly) NSInteger wifiFlow;
@property (nonatomic, readonly) NSInteger wifiInFlow;
@property (nonatomic, readonly) NSInteger wifiOutFlow;
@property (nonatomic, readonly) NSInteger wwanFlow;
@property (nonatomic, readonly) NSInteger wwanInFlow;
@property (nonatomic, readonly) NSInteger wwanOutFlow;

- (instancetype)initWithAllFlow:(NSInteger)allFlow allInFlow:(NSInteger)allInFlow allOutFlow:(NSInteger)allOutFlow wifiFlow:(NSInteger)wifiFlow wifiInFlow:(NSInteger)wifiInFlow wifiOutFlow:(NSInteger)wifiOutFlow wwanFlow:(NSInteger)wwanFlow wwanInFlow:(NSInteger)wwanInFlow wwanOutFlow:(NSInteger)wwanOutFlow;

@end
