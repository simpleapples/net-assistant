//
//  GlanceController.m
//  上网助手 WatchKit Extension
//
//  Created by Zzy on 6/2/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "GlanceController.h"
#import "SAGlobalHolder.h"

@interface GlanceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *flowPercentLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
}

- (void)willActivate
{
    [super willActivate];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
        NSInteger percent = 0;
        if (holder.remainedFlow > 0) {
            percent = holder.remainedFlow * 100.0f / holder.packageFlow;
        }
        UIColor *color = [holder colorWithPercent:percent];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.flowPercentLabel.text = [NSString stringWithFormat:@"%zd%%", percent];
            [self.flowPercentLabel setTextColor:color];
        });
    });
}

- (void)didDeactivate
{
    [super didDeactivate];
}

@end



