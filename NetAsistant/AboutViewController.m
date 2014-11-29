//
//  AboutViewController.m
//  NetAsistant
//
//  Created by Zzy on 11/29/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>

@interface AboutViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *versionStr = [NSString stringWithFormat:@"%@ Build %@", [info objectForKey:@"CFBundleShortVersionString"], [info objectForKey:@"CFBundleVersion"]];
    self.versionLabel.text = versionStr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
            NSString *versionStr = [NSString stringWithFormat:@"%@ Build %@", [info objectForKey:@"CFBundleShortVersionString"], [info objectForKey:@"CFBundleVersion"]];
            NSString *message = [[NSString alloc] initWithFormat:@"设备: %@ %@, 软件版本: %@ \n\n请在这里填写您的反馈内容", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], versionStr];
            __weak id target = self;
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = target;
            [mailViewController setToRecipients:@[@"netassistant@simpleapples.com"]];
            [mailViewController setSubject:@"用户反馈"];
            [mailViewController setMessageBody:message isHTML:NO];
            if (![MFMailComposeViewController canSendMail]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用您的邮箱" message:@"请在邮件应用中添加邮箱后再试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            } else {
                [self presentViewController:mailViewController animated:YES completion:nil];
            }
        } else if (indexPath.row == 1) {
            NSString *urlStr = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=922017358";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
