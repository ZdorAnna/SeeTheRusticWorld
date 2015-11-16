//
//  STServerManager.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STServerManager.h"
#import "STDefines.h"

#import <AFNetworking/AFNetworking.h>

@implementation STServerManager

+ (instancetype)sharedManager {
    static STServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STServerManager alloc] init];
    });
    
    return manager;
}

- (NSURLRequest *)userAuthorizationRequest {
    NSString *uriString = [NSString stringWithFormat:STInstagramAuthorizationRequestString, STInstagramClientId,
                           STInstagramCallbackString];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:uriString]];
}

- (void)requestTokenWithCode:(NSString *)code
                     onSuccess:(STTokenBlock)success
                     onFailure:(STErrorBlock)failure {
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    NSDictionary *parametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          code,                      @"code",
                                          STInstagramCallbackString, @"redirect_uri",
                                          @"authorization_code",     @"grant_type",
                                          STInstagramClientId,       @"client_id",
                                          STInstagramClientSecret,   @"client_secret",
                                          nil];
    [manager POST:STInstagramAccessTokenRequestString
       parameters:parametersDictionary
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *accessToken = [responseObject objectForKey:STInstagramTokenKey];
              NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
              [userDefaults setObject:accessToken forKey:STInstagramTokenKey];
              [userDefaults synchronize];

              if (success) {
                  success (accessToken);
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults setObject:accessToken forKey:STInstagramTokenKey];
                  [userDefaults synchronize];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure (error, [error code]);
              }
          }];
}

- (void)requestRecentPostsFromServerWithPageUrl:(NSString *)url
                                      onSuccess:(STPostsDictionaryBlock)success
                                      onFailure:(STErrorBlock)failure {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults objectForKey:STInstagramTokenKey];
    
    if (accessToken) {
        NSDictionary *parameters = [NSDictionary new];
        NSString *URLString;
        
        if (!url) {
            parameters = @{
                           STInstagramTokenKey : accessToken,
                           @"count"            : [NSString stringWithFormat:@"%lu", STCountPostsInRequest]
                           };
            URLString = [NSString stringWithFormat:STInstagramPostsRequestString, STInstagramTagName];
            
        } else {
            parameters = nil;
            URLString = url;
        }

        AFHTTPRequestOperationManager *requestOperationManager = [AFHTTPRequestOperationManager manager];
        [requestOperationManager GET:URLString
                          parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 if (success) {
                                     success(responseObject);
                                 }
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 if (failure) {
                                     failure(error, [error code]);
                                 }
                             }];
    }
}

@end
