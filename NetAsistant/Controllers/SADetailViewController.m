//
//  SADetailViewController.m
//  NetAsistant
//
//  Created by Zzy on 3/7/15.
//  Copyright (c) 2015 Zzy. All rights reserved.
//

#import "SADetailViewController.h"
#import "SADetailCell.h"
#import "SADetail.h"
#import "SACoreDataManager.h"

@interface SADetailViewController ()

@property (strong, nonatomic) NSArray *details;
@property (nonatomic, getter = isCellRegistered) BOOL cellRegistered;

@end

@implementation SADetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    
    [[SACoreDataManager manager] detailsOfThisMonth:^(NSArray *details) {
        if (details) {
            self.details = details;
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SADetailCell";
    if (indexPath.row < self.details.count) {
        SADetail *detail = [self.details objectAtIndex:indexPath.row];
        SADetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell configWithDetail:detail];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.details.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
