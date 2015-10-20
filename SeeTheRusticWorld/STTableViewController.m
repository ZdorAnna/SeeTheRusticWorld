//
//  ViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STTableViewController.h"
#import "STTableViewCell.h"
#import "STDataSource.h"

NSString *const STTableViewControllerIdentifier = @"STTableViewControllerIdentifier";
#define MIN_COUNT_CELLS 12

@interface STTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation STTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[STDataSource alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource contentCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    [cell setContent:[self.dataSource contentAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSource contentCount] >= MIN_COUNT_CELLS) {
        if (indexPath.row == ([self.dataSource contentCount] - 1)){
            [self.dataSource loadNextPage];
        }
    }
}

@end
