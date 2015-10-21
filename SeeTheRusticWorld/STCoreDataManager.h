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

#warning в *.h файле необходимо показать только managedObjectContext, и тот только readonly. Остальные свойства используются только внутри класса
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (STCoreDataManager *)sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
