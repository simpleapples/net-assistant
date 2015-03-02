//
//  InfoViewController.m
//  NetAsistant
//
//  Created by Zzy on 10/16/14.
//  Copyright (c) 2014 Zzy. All rights reserved.
//

#import "SAInfoViewController.h"

@implementation SAInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onCloseButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
