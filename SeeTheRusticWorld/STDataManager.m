//
//  STDataManager.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/19/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STDataManager.h"
#import "STServerManager.h"

@implementation STDataManager

//-(void)mappingPostsDictionary:(STMappingBlock)completionBlock {
//    
//    NSMutableArray *tempArray = [NSMutableArray array];
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *url = [userDefaults objectForKey:@"nextPageUrl"];
//    NSLog(@"%@", url);
//    
//    [[STServerManager sharedManager] recentPostsFromServerWithPageUrl:url onSuccess:^(NSDictionary *posts) {
//        NSArray *dataArray = [posts objectForKey:@"data"];
//        
//        for (NSDictionary *dict in dataArray) {
//            
//            NSDictionary *captionDictionary = [dict objectForKey:@"caption"];
//            
//            NSString *text = [captionDictionary objectForKey:@"text"];
//            
//            NSString *identifier = [captionDictionary objectForKey:@"id"];
//
//            NSDictionary *imageDictionary = [dict objectForKey:@"images"];
//            NSDictionary *standardResolutionDict = [imageDictionary objectForKey:@"standard_resolution"];
//            NSString *imageURL = [standardResolutionDict objectForKey:@"url"];
//            
//            
//            NSDictionary *dictionaty = @{
//                                         @"text"         : text,
//                                         @"imageURL"     : imageURL,
//                                         @"identifier"   : identifier
//                                         };
//            
//            [tempArray addObject:dictionaty];
//        }
//        
//        NSDictionary *dict = [posts objectForKey:@"pagination"];
//        NSString *nextPageUrl = [dict objectForKey:@"next_url"];
//        
//        NSLog(@"%@", tempArray.description);
//        
//        completionBlock(tempArray, nextPageUrl);
//
//    } onFailure:^(NSError *error, NSInteger statusCode) {
//        completionBlock(nil, nil);
//
//    }];
//    
//}

@end
