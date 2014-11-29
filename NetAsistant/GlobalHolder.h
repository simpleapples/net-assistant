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

@interface GlobalHolder : NSObject

@property (nonatomic) int64_t limitFlow;
@property (nonatomic) int64_t lastFlow;
@property (nonatomic) int64_t offsetFlow;
@property (strong, nonatomic) NSDate *lastDate;

+ (GlobalHolder *)sharedSingleton;

- (UIColor *)colorWithType:(COLOR_TYPE)type;
- (void)backupToFile;
- (void)recoverFromFile;

@end
