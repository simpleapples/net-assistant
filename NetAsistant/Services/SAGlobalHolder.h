//
//  GlobalHolder.h
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, COLOR_TYPE)
{
    COLOR_TYPE_NORMAL = 0,
    COLOR_TYPE_WARNNING,
    COLOR_TYPE_ERROR,
};

@class SANetworkFlow;

@interface SAGlobalHolder : NSObject

@property (nonatomic) int64_t packageFlow;
@property (nonatomic) int64_t lastUsedFlow;
@property (nonatomic) int64_t usedFlow;
@property (nonatomic) int64_t remainedFlow;
@property (strong, nonatomic) NSDate *lastRecordDate;

+ (SAGlobalHolder *)sharedSingleton;

- (void)updateDataWithNetworkFlow:(SANetworkFlow *)networkFlow;

- (UIColor *)colorWithType:(COLOR_TYPE)type;
- (UIColor *)colorWithPercent:(NSInteger)percent;

- (void)backupToFile;
- (void)recoverFromFile;

@end
