//
//  ViewController.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "SAMainViewController.h"
#import "SANetworkFlowService.h"
#import "SANetworkFlow.h"
#import "SAGlobalHolder.h"

@interface SAMainViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *flowPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wwanFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitFlowLabel;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (strong, nonatomic) NSTimer *refreshTimer;

@end

@implementation SAMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    self.calibrateButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.modifyButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SAGlobalHolder sharedSingleton] recoverFromFile];
        NSDate *nowDate = [NSDate date];
        NSDate *lastDate = [SAGlobalHolder sharedSingleton].lastDate;
        if ([SAGlobalHolder sharedSingleton].limitFlow <= 0) {
            [self alertModifyView];
        } else if ([self monthWithDate:nowDate] != [self monthWithDate:lastDate]
                   && [nowDate timeIntervalSince1970] > [lastDate timeIntervalSince1970]) {
            [SAGlobalHolder sharedSingleton].offsetFlow = 0;
            [SAGlobalHolder sharedSingleton].lastDate = [NSDate date];
            [[SAGlobalHolder sharedSingleton] backupToFile];
        }
        self.refreshTimer = nil;
        self.refreshTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onRefreshTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
        [self updateFlowData];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.refreshTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateFlowData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SANetworkFlow *networkFlow = [SANetworkFlowService networkFlow];
        if (networkFlow) {
            int64_t usedFlow = 0;
            if (networkFlow.wwanFlow >= [SAGlobalHolder sharedSingleton].lastFlow) {
                usedFlow = networkFlow.wwanFlow - [SAGlobalHolder sharedSingleton].lastFlow + [SAGlobalHolder sharedSingleton].offsetFlow;
            } else {
                usedFlow = [SAGlobalHolder sharedSingleton].offsetFlow;
            }
            [SAGlobalHolder sharedSingleton].lastFlow = networkFlow.wwanFlow;
            [SAGlobalHolder sharedSingleton].offsetFlow = usedFlow;
            [SAGlobalHolder sharedSingleton].lastDate = [NSDate date];
            
            int64_t remainFlow = [SAGlobalHolder sharedSingleton].limitFlow - usedFlow;
            int64_t limitFlow = [SAGlobalHolder sharedSingleton].limitFlow;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (remainFlow > 0) {
                    NSInteger percent = remainFlow * 100.0f / limitFlow;
                    self.flowPercentLabel.text = [NSString stringWithFormat:@"%ld", (long)percent];
                    if (percent < 10) {
                        self.view.backgroundColor = [[SAGlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_ERROR];
                    } else if (percent < 20) {
                        self.view.backgroundColor = [[SAGlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_WARNNING];
                    } else {
                        self.view.backgroundColor = [[SAGlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_NORMAL];
                    }
                } else {
                    self.flowPercentLabel.text = @"0";
                    self.view.backgroundColor = [[SAGlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_ERROR];
                }
                if (limitFlow > 0) {
                    self.limitFlowLabel.text = [self flowValueToStr:limitFlow];
                }
                self.wwanFlowLabel.text = [self flowValueToStr:usedFlow];
            });
        }
    });
}

- (NSString *)flowValueToStr:(int64_t)bytes
{
    if (bytes < 1000) {
        return [NSString stringWithFormat:@"%lluB", bytes];
    } else if (bytes >= 1000 && bytes < 1000 * 1000) {
        return [NSString stringWithFormat:@"%.1fKB", 1.0 * bytes / 1000];
    } else if (bytes >= 1000 * 1000 && bytes < 1000 * 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2fMB", 1.0 * bytes / (1000 * 1000)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB", 1.0 * bytes / (1000 * 1000 * 1000)];
    }
}

- (NSInteger)monthWithDate:(NSDate *)date
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [cal components:NSCalendarUnitMonth fromDate:date];
    return comp.month;
}

#pragma mark - UIAlertView

- (void)alertModifyView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"修改套餐", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"完成", nil), nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 2;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView textFieldAtIndex:0].placeholder = NSLocalizedString(@"请输入套餐流量（单位MB）", nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    });
}
                                              
- (void)alertCalibrateView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"校准用量", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"完成", nil), nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 1;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView textFieldAtIndex:0].placeholder = NSLocalizedString(@"请输入已使用流量（单位MB）", nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    });
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && [alertView textFieldAtIndex:0].text.length > 0) {
        if (alertView.tag == 1) {
            [SAGlobalHolder sharedSingleton].offsetFlow = [[alertView textFieldAtIndex:0].text floatValue] * 1000 * 1000;
            [SAGlobalHolder sharedSingleton].lastDate = [NSDate date];
        } else if (alertView.tag == 2) {
            [SAGlobalHolder sharedSingleton].limitFlow = [[alertView textFieldAtIndex:0].text floatValue] * 1000 * 1000;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateFlowData];
            [[SAGlobalHolder sharedSingleton] backupToFile];
        });
    }
}

#pragma mark - Handler

- (IBAction)onCalibrateButtonClick:(id)sender
{
    [self alertCalibrateView];
}

- (IBAction)onModifyButtonClick:(id)sender
{
    [self alertModifyView];
}

- (void)onRefreshTimer
{
    [self updateFlowData];
}

@end
