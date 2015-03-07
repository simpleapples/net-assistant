//
//  SADetail.h
//  NetAsistant
//
//  Created by Zzy on 3/7/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SADetail : NSManagedObject

@property (nonatomic, retain) NSNumber * flowValue;
@property (nonatomic, retain) NSDate * date;

@end
