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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wwanFlowLabel;
@property (weak, nonatomic) IBOutlet UILabel *wwanOutFlow;
@property (weak, nonatomic) IBOutlet UILabel *wwanInFlow;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateFlowData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateFlowData
{
    NetworkFlow *networkFlow = [NetworkFlowService networkFlow];
    if (networkFlow) {
        self.wwanFlowLabel.text = [self flowValueToStr:networkFlow.wwanFlow];
        self.wwanInFlow.text = [self flowValueToStr:networkFlow.wwanInFlow];
        self.wwanOutFlow.text = [self flowValueToStr:networkFlow.wwanOutFlow];
    }
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

@end
