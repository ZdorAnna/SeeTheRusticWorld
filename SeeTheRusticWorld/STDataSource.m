//
//  STDataSource.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/14/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STDataSource.h"
#import "STCoreDataManager.h"
#import "STDataManager.h"
#import "STDefines.h"

@interface STDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id<NSFetchedResultsControllerDelegate> delegate;

@end

@implementation STDataSource

#pragma mark - STDataSource methods

- (instancetype)initWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
        if ([self contentCount] < STCountPostsInRequest - 1) {
            [self loadNextPage];
        }
    }
    return self;
}

- (STPost *)contentAtIndexPath:(NSIndexPath *)indexPath {
    STPost *content = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return content;
}

- (NSInteger)contentCount {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (void)loadNextPage {
    STDataManager *dataManager = [[STDataManager alloc] initWithFetchResultController:self.fetchedResultsController
                                                                     managedObjectContext:self.managedObjectContext];
    [dataManager loadNextPage];
}

- (NSManagedObjectContext*) managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[STCoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Fetched results controller

 - (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"STPost"
                                              inManagedObjectContext:self.managedObjectContext];
     
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:STCountPostsInRequest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTime" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    self.fetchedResultsController.delegate = self.delegate;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
     
    return _fetchedResultsController;
}

@end

