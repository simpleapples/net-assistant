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

+ (void)initialize
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    }
}

+ (NSInteger)yearWithDate:(NSDate *)date
{
    [dateFormatter setDateFormat:@"YYYY"];
    return [dateFormatter stringFromDate:date].integerValue;
}

+ (NSInteger)monthWithDate:(NSDate *)date
{
    [dateFormatter setDateFormat:@"M"];
    return [dateFormatter stringFromDate:date].integerValue;
}

+ (NSInteger)dayWithDate:(NSDate *)date
{
    [dateFormatter setDateFormat:@"d"];
    return [dateFormatter stringFromDate:date].integerValue;
}

+ (NSString *)stringWithDate:(NSDate *)date
{
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"M%@d%@", NSLocalizedString(@"月", nil), NSLocalizedString(@"日", nil)]];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dayDateWithStirng:(NSString *)string
{
    [dateFormatter setDateFormat:@"YYYY-M-d HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

@end
