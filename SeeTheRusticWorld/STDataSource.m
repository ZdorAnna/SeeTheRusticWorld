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

#define FETCH_BATCH_SIZE 12
typedef void(^STMappingBlock)(NSArray *postsArray, NSString *nextPage);

@interface STDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *tempArray;

@end

@implementation STDataSource

@synthesize managedObjectContext = _managedObjectContext;

- (NSManagedObjectContext*) managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[STCoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self contentCount] < FETCH_BATCH_SIZE - 1) {
           [self loadNextPage];
        }
    }
    return self;
}

#pragma mark - STDataSource methods

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
    [self mappingPostsDictionary:^(NSArray *postsArray, NSString *nextPage) {
        for (int i = 0; i < [postsArray count]; i++) {
            [self addModelWithImageURL:[postsArray[i] objectForKey:@"imageURL"]
                                  text:[postsArray[i] objectForKey:@"text"]
                       modelIdentifier:[postsArray[i] objectForKey:@"identifier"]];
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nextPage forKey:@"nextPageUrl"];
        [userDefaults synchronize];
    }];
}

#pragma mark - Methods

- (void)addModelWithImageURL:(NSString *)imageURL text:(NSString *)text modelIdentifier:(NSString *)identifier {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"STPost"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(identifier = %@)", identifier];
    [request setPredicate:predicate];
    
    NSError *requestError = nil;
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    if ([resultArray count] > 0) {
        STPost *post= resultArray[0];
        post.text = text;
        post.imageURL = imageURL;
        post.createdTime = [NSDate date];
        
        NSLog(@"%@ %@", post.text, post.imageURL);
        [post.managedObjectContext save:nil];
    } else {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                                          inManagedObjectContext:context];
        
        [newManagedObject setValue:text forKey:@"text"];
        [newManagedObject setValue:imageURL forKey:@"imageURL"];
        [newManagedObject setValue:identifier forKey:@"identifier"];
        [newManagedObject setValue:[NSDate date] forKey:@"createdTime"];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)mappingPostsDictionary:(STMappingBlock)completionBlock {
    
    self.tempArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:@"nextPageUrl"];
    
    [[STServerManager sharedManager] recentPostsFromServerWithPageUrl:url onSuccess:^(NSDictionary *posts) {
        
        NSDictionary *dict = [posts objectForKey:@"pagination"];
        
        NSString *nextPageUrl = [dict objectForKey:@"next_url"];
        
        NSArray *dataArray = [posts objectForKey:@"data"];
        
        for (int i = 0; i < [dataArray count]; i++) {
            
            NSLog(@"for %d", i);
            NSDictionary *dict = [dataArray objectAtIndex:i];
            
            NSDictionary *captionDictionary = [dict objectForKey:@"caption"];
            
            NSString *text = [captionDictionary objectForKey:@"text"];
            

            NSString *identifier = [captionDictionary objectForKey:@"id"];
            
            NSDictionary *imageDictionary = [dict objectForKey:@"images"];
            NSDictionary *standardResolutionDict = [imageDictionary objectForKey:@"standard_resolution"];
            NSString *imageURL = [standardResolutionDict objectForKey:@"url"];
            
            
            NSDictionary *dictionaty = @{
                                         @"text"         : text,
                                         @"imageURL"     : imageURL,
                                         @"identifier"   : identifier
                                         };
            
            [self.tempArray addObject:dictionaty];
        }
        completionBlock(self.tempArray, nextPageUrl);
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        completionBlock(nil, nil);
        
    }];
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
    [fetchRequest setFetchBatchSize:FETCH_BATCH_SIZE];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTime" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _fetchedResultsController;
}

@end

