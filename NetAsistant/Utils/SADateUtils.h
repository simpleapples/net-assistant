//
//  SADateUtils.h
//  NetAsistant
//
//  Created by Zzy on 3/7/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SADateUtils : NSObject

+ (NSInteger)yearWithDate:(NSDate *)date;
+ (NSInteger)monthWithDate:(NSDate *)date;
+ (NSInteger)dayWithDate:(NSDate *)date;

+ (NSString *)stringWithDate:(NSDate *)date;
+ (NSDate *)dayDateWithStirng:(NSString *)string;

@end
