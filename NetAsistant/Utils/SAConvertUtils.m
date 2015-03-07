//
//  SAConvertUtils.m
//  NetAsistant
//
//  Created by Zzy on 3/7/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "SAConvertUtils.h"

@implementation SAConvertUtils

+ (NSString *)bytesToString:(int64_t)bytes
{
    if (bytes < 1000) {
        return [NSString stringWithFormat:@"%lluB", bytes];
    } else if (bytes >= 1000 && bytes < 1000 * 1000) {
        return [NSString stringWithFormat:@"%.1fKB", 1.0 * bytes / 1000];
    } else if (bytes >= 1000 * 1000 && bytes < 1000 * 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2fMB", 1.0 * bytes / (1000 * 1000)];
    }
    return [NSString stringWithFormat:@"%.2fGB", 1.0 * bytes / (1000 * 1000 * 1000)];
}

@end
