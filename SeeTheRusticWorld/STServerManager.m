//
//  STServerManager.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STServerManager.h"
#import "STAccessToken.h"
#import "AFNetworking.h"
#import "STLoginViewController.h"

@interface STServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong, nonatomic) STAccessToken *accessToken;

@end

@implementation STServerManager

+ (STServerManager *)sharedManager {
    static STServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STServerManager alloc] init];
    });
    
    return manager;
}

- (void)authorizeUser {
    
    STLoginViewController *vc = [[STLoginViewController alloc]
                                 initWithCompletionBlock:^(STAccessToken *token) {
        self.accessToken = token;
//        if (token) {
//            
//        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}

- (NSURLRequest *)userAuthorizationRequest {
    NSString *uriString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&display=touch&basic&redirect_uri=%@&response_type=code", INSTAGRAM_CLIENT_ID, INSTAGRAM_CALLBACK_BASE];
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:uriString]];
}

- (void)recentPostsForTagName:(NSString *)tagName
                        count:(NSUInteger)count
                     maxTagID:(NSString *)maxTagID
                    onSuccess:(void(^)(id responseObject))success
                    onFailure:(void(^)(NSError *error))failure {
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent", tagName];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (self.accessToken) {
        parameters[@"access_token"] = self.accessToken;
    }
    parameters[@"count"] = @(count);
    if (maxTagID) {
        parameters[@"max_tag_id"] = maxTagID;
    }
    
    self.requestOperationManager = [AFHTTPRequestOperationManager manager];
    
    [self.requestOperationManager GET:URLString
                  parameters:[parameters copy]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (success) {
                             success(responseObject);
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (failure) {
                             failure(error);
                         }
                     }];
}

@end
