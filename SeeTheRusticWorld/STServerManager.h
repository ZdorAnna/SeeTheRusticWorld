//
//  STServerManager.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^STPostsDictionaryBlock)(NSDictionary *posts);

typedef void(^STTokenBlock)(NSString *accessToken);

typedef void(^STErrorBlock)(NSError* error, NSInteger statusCode);

@interface STServerManager : NSObject

+ (STServerManager *)sharedManager;
- (NSURLRequest *)userAuthorizationRequest;

- (void)getTokenWithCode:(NSString *)code
               onSuccess:(STTokenBlock)success
               onFailure:(STErrorBlock)failure;

- (void)recentPostsFromServerWithPageUrl:(NSString *)url
                               onSuccess:(STPostsDictionaryBlock)success
                               onFailure:(STErrorBlock)failure;
@end


