//
//  GlobalHolder.h
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHolder : NSObject

@property (nonatomic) NSInteger flowLimit;

+ (GlobalHolder *)sharedSingleton;

@end
