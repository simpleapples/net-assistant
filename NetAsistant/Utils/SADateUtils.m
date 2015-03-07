//
//  SADateUtils.m
//  NetAsistant
//
//  Created by Zzy on 3/7/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "SADateUtils.h"

@implementation SADateUtils

static NSDateFormatter *dateFormatter;

+ (NSInteger)yearWithDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    [dateFormatter setDateFormat:@"YYYY"];
    return [dateFormatter stringFromDate:date].integerValue;
}

+ (NSInteger)monthWithDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    [dateFormatter setDateFormat:@"M"];
    return [dateFormatter stringFromDate:date].integerValue;
}

+ (NSInteger)dayWithDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    [dateFormatter setDateFormat:@"d"];
    return [dateFormatter stringFromDate:date].integerValue;
}

+ (NSString *)stringWithDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"M%@d%@", NSLocalizedString(@"月", nil), NSLocalizedString(@"日", nil)]];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dayDateWithStirng:(NSString *)string
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    [dateFormatter setDateFormat:@"YYYY-M-d HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

@end
