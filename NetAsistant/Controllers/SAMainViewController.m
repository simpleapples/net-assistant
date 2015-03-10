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
#import "SAConvertUtils.h"
#import "SADateUtils.h"

@interface SAMainViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *flowPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wwanFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitFlowLabel;
@property (weak, nonatomic) IBOutlet UIButton *calibrateButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

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
        SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
        NSDate *nowDate = [NSDate date];
        NSDate *lastDate = holder.lastRecordDate;
        if (holder.packageFlow <= 0) {
            [self alertModifyView];
        } else if ([SADateUtils monthWithDate:nowDate] != [SADateUtils monthWithDate:lastDate]
                   && [nowDate timeIntervalSince1970] > [lastDate timeIntervalSince1970]) {
            [holder cleanFlowOfLastMonth];
        }
        [self updateFlowData];
    });
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SAGlobalHolder sharedSingleton] updateDataWithNetworkFlow:networkFlow];
                [self updateInterface];
            });
        }
    });
}

- (void)updateInterface
{
    SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
    if (holder.remainedFlow > 0) {
        NSInteger percent = holder.remainedFlow * 100.0f / holder.packageFlow;
        self.flowPercentLabel.text = [NSString stringWithFormat:@"%ld", (long)percent];
        self.view.backgroundColor = [holder colorWithPercent:percent];
    } else {
        self.flowPercentLabel.text = @"0";
        self.view.backgroundColor = [holder colorWithType:COLOR_TYPE_ERROR];
    }
    if (holder.packageFlow > 0) {
        self.limitFlowLabel.text = [SAConvertUtils bytesToString:holder.packageFlow];
    }
    self.wwanFlowLabel.text = [SAConvertUtils bytesToString:holder.usedFlow];
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
        SAGlobalHolder *holder = [SAGlobalHolder sharedSingleton];
        if (alertView.tag == 1) {
            int64_t usedFlow = [[alertView textFieldAtIndex:0].text floatValue] * 1000 * 1000;
            [holder calibrateUsedFlow:usedFlow];
        } else if (alertView.tag == 2) {
            int64_t packageFlow = [[alertView textFieldAtIndex:0].text floatValue] * 1000 * 1000;
            [holder updatePackageFlow:packageFlow];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateFlowData];
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

@end
