//
//  SACoreDataManager.h
//  NetAsistant
//
//  Created by Zzy on 12/24/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SADetail.h"

@class SADetail;

@interface SACoreDataManager : NSObject

+ (SACoreDataManager *)manager;

- (void)insertOrUpdateDetailWithFlowValue:(int64_t)flowValue date:(NSDate *)date;
- (void)detailsOfThisMonth:(void(^)(NSArray *details))completionBlock;

- (void)saveContext;

@end
