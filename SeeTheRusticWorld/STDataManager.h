//
//  STDataManager.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/20/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSFetchedResultsController;
@class NSManagedObjectContext;

@interface STDataManager : NSObject

- (instancetype)initWithFetchResultController:(NSFetchedResultsController *)fetchedResultsController
                         managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)loadNextPage;

@end
