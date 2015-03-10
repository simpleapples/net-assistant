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

@property (nonatomic, readonly) int64_t packageFlow;
@property (nonatomic, readonly) int64_t usedFlow;
@property (nonatomic, readonly) int64_t remainedFlow;
@property (nonatomic, readonly) int64_t lastRecordFlow;
@property (strong, nonatomic, readonly) NSDate *lastRecordDate;

+ (SAGlobalHolder *)sharedSingleton;

- (void)updateDataWithNetworkFlow:(SANetworkFlow *)networkFlow;
- (void)updatePackageFlow:(int64_t)packageFlow;
- (void)calibrateUsedFlow:(int64_t)usedFlow;
- (void)cleanFlowOfLastMonth;

- (UIColor *)colorWithType:(COLOR_TYPE)type;
- (UIColor *)colorWithPercent:(NSInteger)percent;

- (void)backupToFile;
- (void)recoverFromFile;

@end
