//
//  STServerManager.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STServerManager.h"
#import "AFNetworking.h"

@interface STServerManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation STServerManager
static NSString *const kTagsCount  = @"12";

+ (STServerManager *)sharedManager {
    static STServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STServerManager alloc] init];
    });
    
    return manager;
}

- (NSURLRequest *)userAuthorizationRequest {
    NSString *uriString = [NSString stringWithFormat:STInstagramAuthorizationRequestString, STInstagramClientId, STInstagramCallbackString];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:uriString]];
}

- (void)getTokenWithCode:(NSString *)code
                     onSuccess:(STTokenBlock)success
                     onFailure:(STErrorBlock)failure{
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    NSDictionary *parametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          code, @"code",
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

- (void)recentPostsFromServerWithPageUrl:(NSString *)url
                               onSuccess:(STPostsDictionaryBlock)success
                               onFailure:(STErrorBlock)failure {
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults objectForKey:STInstagramTokenKey];
    
    if (accessToken) {
        NSDictionary *parameters = @{
                                     STInstagramTokenKey : accessToken,
                                     @"count"            : kTagsCount
                                     };
        
        NSString *URLString = [NSString stringWithFormat:STInstagramPostsRequestString, STInstagramTagName];
#warning зачем хранить requestOperationManager в свойстве, если при каждом запросе вы все равно заполняете его из [AFHTTPRequestOperationManager manager]
        self.requestOperationManager = [AFHTTPRequestOperationManager manager];
#warning здесь в if и else жесткая копипаста, различие только в урле. Поэтому правильно будет в if-else определить, на какой урл нужно отправлять запрос, и затем написать логику отправки один раз
        if (!url) {
            [self.requestOperationManager GET:URLString
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
        } else {
            [self.requestOperationManager GET:url
                                   parameters:nil
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
}

@end
