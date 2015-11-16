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
#import "STDefines.h"

NSString *const STTableViewControllerIdentifier = @"STTableViewControllerIdentifier";

@interface STTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@end

@implementation STTableViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.dataSource = [[STDataSource alloc] initWithDelegate:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource contentCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[STTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STTableViewCellIdentifier];
    }
    
    [cell setContent:[self.dataSource contentAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([self.dataSource contentCount] >= FETCH_BATCH_SIZE) && (indexPath.row == ([self.dataSource contentCount] - 6))) {       [self.dataSource loadNextPage];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
        
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView reloadData];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadData];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView reloadData];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


@end
