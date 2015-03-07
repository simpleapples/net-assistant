//
//  TodayViewController.m
//  Extension
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "TodayViewController.h"
#import "SANetworkFlow.h"
#import "SANetworkFlowService.h"
#import "SAGlobalHolder.h"
#import "SAConvertUtils.h"
#import "SADateUtils.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *usedFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *unusedFlowLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressHoverView;
@property (weak, nonatomic) IBOutlet UIView *highlightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWith;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SAGlobalHolder sharedSingleton] recoverFromFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *nowDate = [NSDate date];
        SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
        if (holder.lastRecordDate && [SADateUtils monthWithDate:nowDate] != [SADateUtils monthWithDate:holder.lastRecordDate]
            && [nowDate timeIntervalSince1970] > [holder.lastRecordDate timeIntervalSince1970]) {
            holder.usedFlow = 0;
            holder.lastRecordDate = [NSDate date];
            [holder backupToFile];
        }
        [self updateNetworkFlow];
    });
}

- (void)updateNetworkFlow
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
        SANetworkFlow *networkFlow = [SANetworkFlowService networkFlow];
        if (networkFlow) {
            [holder updateDataWithNetworkFlow:networkFlow];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usedFlowLabel.text = [SAConvertUtils bytesToString:holder.usedFlow];
                self.limitFlowLabel.text = [NSString stringWithFormat:NSLocalizedString(@"套餐总量: %@", nil), [SAConvertUtils bytesToString:holder.packageFlow]];
                self.unusedFlowLabel.text = [SAConvertUtils bytesToString:holder.remainedFlow];
                CGFloat progressWidth = (CGFloat)holder.remainedFlow / (CGFloat)holder.packageFlow * self.progressView.frame.size.width;
                if (progressWidth > self.progressView.frame.size.width) {
                    progressWidth = self.progressView.frame.size.width;
                }
                self.progressWith.constant = progressWidth;
                NSInteger percent = (holder.packageFlow - holder.usedFlow) * 100.0f / holder.packageFlow;
                self.progressHoverView.backgroundColor = [holder colorWithPercent:percent];
                [self.view layoutIfNeeded];
            });
            [holder backupToFile];
        }
    });
}

#pragma mark - Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlightView.hidden = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlightView.hidden = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlightView.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.extensionContext openURL:[NSURL URLWithString:@"NetAsistant://"] completionHandler:nil];
    });
}

@end
