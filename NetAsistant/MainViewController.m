//
//  ViewController.m
//  NetAsistant
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkFlowService.h"
#import "NetworkFlow.h"
#import "GlobalHolder.h"

@interface MainViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *flowPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wwanFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitFlowLabel;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (strong, nonatomic) NSTimer *refreshTimer;

@end

@implementation MainViewController

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
    [[GlobalHolder sharedSingleton] recoverFromFile];
    NSDate *nowDate = [NSDate date];
    NSDate *lastDate = [GlobalHolder sharedSingleton].lastDate;
    if ([GlobalHolder sharedSingleton].limitFlow <= 0) {
        [self alertModifyView];
    } else if ([self monthWithDate:nowDate] != [self monthWithDate:lastDate]
               && [nowDate timeIntervalSince1970] > [lastDate timeIntervalSince1970]) {
        [GlobalHolder sharedSingleton].offsetFlow = 0;
        [GlobalHolder sharedSingleton].lastDate = [NSDate date];
        [[GlobalHolder sharedSingleton] backupToFile];
    }
    [self updateFlowData];
    
    self.refreshTimer = nil;
    self.refreshTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onRefreshTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
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
    NetworkFlow *networkFlow = [NetworkFlowService networkFlow];
    if (networkFlow) {
        int64_t usedFlow = networkFlow.wwanFlow - [GlobalHolder sharedSingleton].lastFlow + [GlobalHolder sharedSingleton].offsetFlow;
        int64_t remainFlow = [GlobalHolder sharedSingleton].limitFlow - usedFlow;
        int64_t limitFlow = [GlobalHolder sharedSingleton].limitFlow;
        if (remainFlow > 0) {
            NSInteger percent = remainFlow * 100.0f / limitFlow;
            self.flowPercentLabel.text = [NSString stringWithFormat:@"%ld", (long)percent];
            if (percent < 10) {
                self.view.backgroundColor = [[GlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_ERROR];
            } else if (percent < 20) {
                self.view.backgroundColor = [[GlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_WARNNING];
            } else {
                self.view.backgroundColor = [[GlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_NORMAL];
            }
        } else {
            self.flowPercentLabel.text = @"0";
            self.view.backgroundColor = [[GlobalHolder sharedSingleton] colorWithType:COLOR_TYPE_ERROR];
        }
        if (limitFlow > 0) {
            self.limitFlowLabel.text = [self flowValueToStr:limitFlow];
        }
        self.wwanFlowLabel.text = [self flowValueToStr:usedFlow];
        [GlobalHolder sharedSingleton].lastFlow = networkFlow.wwanFlow;
        [GlobalHolder sharedSingleton].offsetFlow = usedFlow;
        [GlobalHolder sharedSingleton].lastDate = [NSDate date];
    }
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
        return [NSString stringWithFormat:@"%.3fGB", 1.0 * bytes / (1000 * 1000 * 1000)];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改套餐" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 2;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:0].placeholder = @"请输入套餐流量（单位MB）";
    [alertView show];
}
                                              
- (void)alertCalibrateView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"校准用量" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:0].placeholder = @"请输入已使用流量（单位MB）";
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && [alertView textFieldAtIndex:0].text.length > 0) {
        if (alertView.tag == 1) {
            [GlobalHolder sharedSingleton].offsetFlow = [[alertView textFieldAtIndex:0].text floatValue] * 1000 * 1000;
            [GlobalHolder sharedSingleton].lastDate = [NSDate date];
        } else if (alertView.tag == 2) {
            [GlobalHolder sharedSingleton].limitFlow = [[alertView textFieldAtIndex:0].text floatValue] * 1000 * 1000;
        }
        [self updateFlowData];
        [[GlobalHolder sharedSingleton] backupToFile];
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
