//
//  STDataManager.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/20/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STDataManager.h"
#import <CoreData/CoreData.h>
#import "STServerManager.h"
#import "STPost.h"

typedef void(^STMappingBlock)(NSArray *postsArray, NSString *nextPage);

@interface STDataManager ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation STDataManager

- (instancetype)initWithFetchResultController:(NSFetchedResultsController *)fetchedResultsController
                         managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        self.fetchedResultsController = fetchedResultsController;
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)loadNextPage {
    [self parsingResponseToPostsArray:^(NSArray *postsArray, NSString *nextPage) {
        for (int i = 0; i < [postsArray count]; i++) {
            [self insertModelWithImageURL:[postsArray[i] objectForKey:@"imageUrlString"]
                                     text:[postsArray[i] objectForKey:@"text"]
                          modelIdentifier:[postsArray[i] objectForKey:@"identifier"]];
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nextPage forKey:@"nextPageUrl"];
        [userDefaults synchronize];
    }];
}

#pragma mark - Methods

- (void)insertModelWithImageURL:(NSString *)imageUrlString text:(NSString *)text modelIdentifier:(NSString *)identifier {
    
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
        post.imageUrlString = imageUrlString;
        post.createdTime = [NSDate date];
        
        [post.managedObjectContext save:nil];
    } else {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                                          inManagedObjectContext:context];
        
        [newManagedObject setValue:text forKey:@"text"];
        [newManagedObject setValue:imageUrlString forKey:@"imageUrlString"];
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

-(void)parsingResponseToPostsArray:(STMappingBlock)completionBlock {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefaults objectForKey:@"nextPageUrl"];
    
    [[STServerManager sharedManager] requestRecentPostsFromServerWithPageUrl:url onSuccess:^(NSDictionary *posts) {
        
        NSDictionary *dict = [posts objectForKey:@"pagination"];
        NSString *nextPageUrl = [dict objectForKey:@"next_url"];
        
        NSArray *dataArray = [posts objectForKey:@"data"];
        for (int i = 0; i < [dataArray count]; i++) {
            
            NSDictionary *dict = [dataArray objectAtIndex:i];
            NSString *text;
            
            if ([dict objectForKey:@"caption"]== [NSNull null]) {
                text = [NSString stringWithFormat:@" "];
                
            } else {
                NSDictionary *captionDictionary = [dict objectForKey:@"caption"];
                text = [captionDictionary objectForKey:@"text"];
            }
            NSString *identifier = [dict objectForKey:@"id"];
            
            NSDictionary *imageDictionary = [dict objectForKey:@"images"];
            NSDictionary *standardResolutionDict = [imageDictionary objectForKey:@"standard_resolution"];
            NSString *imageUrlString = [standardResolutionDict objectForKey:@"url"];
            
            NSDictionary *dictionaty = @{
                                         @"text"               : text,
                                         @"imageUrlString"     : imageUrlString,
                                         @"identifier"         : identifier
                                         };
            
            [tempArray addObject:dictionaty];
        }
        completionBlock(tempArray, nextPageUrl);
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        completionBlock(nil, nil);
        
    }];
}

@end
