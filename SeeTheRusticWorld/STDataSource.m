//
//  STDataSource.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/14/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STDataSource.h"
#import "STServerManager.h"
#import "STCoreDataManager.h"
#import "STPost.h"

@interface STDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation STDataSource

@synthesize managedObjectContext = _managedObjectContext;


- (NSManagedObjectContext*) managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[STCoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - MSContentManager methods

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

- (void)requestRecentPost {
    [STServerManager sharedManager] 
    
    
//- (void)saveModelWithImageName:(NSString *)imageName text:(NSString *)text {
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
//                                                                      inManagedObjectContext:context];
//    
//    [newManagedObject setValue:imageName forKey:@"imageName"];
//    [newManagedObject setValue:text forKey:@"text"];
//    
//    NSError *error = nil;
//    if (![context save:&error]) {
//        
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MSContent"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:NO];
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
        abort();
    }
    return _fetchedResultsController;
}

@end

