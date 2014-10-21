//
//  TodayViewController.m
//  Extension
//
//  Created by Zzy on 9/20/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *usedFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *unusedFlowLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressHoverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWith;
@property (nonatomic) NSInteger limitFlow;
@property (nonatomic) NSInteger lastFlow;
@property (nonatomic) NSInteger offsetFlow;
@property (strong, nonatomic) NSDate *lastDate;
@property (strong, nonatomic) NSArray *colorArray;
@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self recoverFromFile];
    
    UIColor *yellow = [UIColor colorWithRed:252 / 255.0f green:176 / 255.0f blue:60 / 255.0f alpha:1.0f];
    UIColor *red = [UIColor colorWithRed:252 / 255.0f green:91 / 255.0f blue:63 / 255.0f alpha:1.0f];
    UIColor *green = [UIColor colorWithRed:111 / 255.0f green:213 / 255.0f blue:127 / 255.0f alpha:1.0f];
    self.colorArray = [[NSArray alloc] initWithObjects:green, yellow, red, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
    NSDate *nowDate = [NSDate date];
    if (self.lastDate && [self monthWithDate:nowDate] != [self monthWithDate:self.lastDate]
        && [nowDate timeIntervalSince1970] > [self.lastDate timeIntervalSince1970]) {
        self.offsetFlow = 0;
        self.lastDate = [NSDate date];
        [self backupToFile];
    }
    [self updateNetworkFlow];
}

- (void)updateNetworkFlow
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return;
    }
    
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    uint32_t wifiIBytes = 0;
    uint32_t wifiOBytes = 0;
    uint32_t wifiFlow   = 0;
    uint32_t wwanIBytes = 0;
    uint32_t wwanOBytes = 0;
    uint32_t wwanFlow   = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family) {
            continue;
        }
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING)) {
            continue;
        }
        if (ifa->ifa_data == 0) {
            continue;
        }
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
        if (!strcmp(ifa->ifa_name, "en0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wifiIBytes += if_data->ifi_ibytes;
            wifiOBytes += if_data->ifi_obytes;
            wifiFlow    = wifiIBytes + wifiOBytes;
        }
        if (!strcmp(ifa->ifa_name, "pdp_ip0")) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            wwanIBytes += if_data->ifi_ibytes;
            wwanOBytes += if_data->ifi_obytes;
            wwanFlow    = wwanIBytes + wwanOBytes;
        }
    }
    freeifaddrs(ifa_list);
    
    NSInteger usedFlow = wwanFlow - self.lastFlow + self.offsetFlow;
    if (usedFlow < 0) {
        usedFlow = 0;
    }
    self.usedFlowLabel.text = [self flowValueToStr:usedFlow];
    self.limitFlowLabel.text = [NSString stringWithFormat:@"套餐总量: %@", [self flowValueToStr:self.limitFlow]];
    NSInteger unusedFlow = self.limitFlow - usedFlow;
    if (unusedFlow < 0) {
        unusedFlow = 0;
    }
    self.unusedFlowLabel.text = [self flowValueToStr:unusedFlow];
    self.progressWith.constant = (CGFloat)usedFlow / (CGFloat)self.limitFlow * self.progressView.frame.size.width;
    
    NSInteger percent = (self.limitFlow - usedFlow) * 100.0f / self.limitFlow;
    if (percent < 10) {
        self.progressHoverView.backgroundColor = [self.colorArray objectAtIndex:2];
    } else if (percent < 20) {
        self.progressHoverView.backgroundColor = [self.colorArray objectAtIndex:1];
    } else {
        self.progressHoverView.backgroundColor = [self.colorArray objectAtIndex:0];
    }
    
    [self.view layoutIfNeeded];
    
    [self backupToFile];
}

- (NSString *)flowValueToStr:(NSInteger)bytes
{
    if (bytes < 1024) {
        return [NSString stringWithFormat:@"%ldB", (long)bytes];
    } else if (bytes >= 1024 && bytes < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    } else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    } else {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

- (void)backupToFile
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.netasistant"];
    [userDefaults setInteger:self.limitFlow forKey:@"limitFlow"];
    [userDefaults setInteger:self.lastFlow forKey:@"lastFlow"];
    [userDefaults setInteger:self.offsetFlow forKey:@"offsetFlow"];
    [userDefaults setObject:self.lastDate forKey:@"lastDate"];
    [userDefaults synchronize];
}

- (void)recoverFromFile
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.netasistant"];
    self.limitFlow = [userDefaults integerForKey:@"limitFlow"];
    self.lastFlow = [userDefaults integerForKey:@"lastFlow"];
    self.offsetFlow = [userDefaults integerForKey:@"offsetFlow"];
    self.lastDate = [userDefaults objectForKey:@"lastDate"];
}

- (NSInteger)monthWithDate:(NSDate *)date
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [cal components:NSCalendarUnitMonth fromDate:date];
    return comp.month;
}

- (IBAction)onModifyButtonClick:(id)sender
{
    [self.extensionContext openURL:[NSURL URLWithString:@"NetAsistant://"] completionHandler:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.extensionContext openURL:[NSURL URLWithString:@"NetAsistant://"] completionHandler:nil];
}

@end
