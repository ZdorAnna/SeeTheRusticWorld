//
//  STRWCoreDataManager.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface STCoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (STCoreDataManager *)sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
