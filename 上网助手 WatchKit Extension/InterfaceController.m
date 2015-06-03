//
//  InterfaceController.m
//  上网助手 WatchKit Extension
//
//  Created by Zzy on 6/2/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "InterfaceController.h"
#import "SAGlobalHolder.h"
#import "SAConvertUtils.h"

@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *flowPercentLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *remainedFlowLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *remainedFlowGroup;

@end


@implementation InterfaceController

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
            self.remainedFlowLabel.text = [NSString stringWithFormat:@"%@可用", [SAConvertUtils bytesToString:holder.remainedFlow]];
            [self.remainedFlowGroup setBackgroundColor:color];
        });
    });
}

- (void)didDeactivate
{
    [super didDeactivate];
}

@end



