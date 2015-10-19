//
//  STLoginViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/6/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STLoginViewController.h"
#import "STServerManager.h"
#import "STAccessToken.h"
#import "STPost.h"
#import "AFHTTPRequestOperationManager.h"

@interface STLoginViewController ()

@property (nonatomic, copy) STLoginCompletionBlock completionBlock;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation STLoginViewController

- (id)initWithCompletionBlock:(STLoginCompletionBlock)completionBlock {
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    self.webView.delegate = self;
    
    [self authorize];
    [self.view addSubview:self.webView];
}

- (void)authorize {
    NSURLRequest *request = [[STServerManager sharedManager] userAuthorizationRequest];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"code="].location != NSNotFound) {
        
        NSString *authToken;
        NSString* query = [[request URL] description];
        NSArray* array = [query componentsSeparatedByString:@"?"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        NSArray* values = [query componentsSeparatedByString:@"="];
        if ([values count] == 2) {
            NSString* key = [values firstObject];
            
            if ([key isEqualToString:@"code"]) {
               authToken = [values lastObject];
            }
        }
        
        STAccessToken *accessToken = [[STAccessToken alloc] init];
        AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
        NSDictionary *parametersDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   authToken, @"code",
                                   INSTAGRAM_CALLBACK_BASE, @"redirect_uri",
                                   @"authorization_code", @"grant_type",
                                   INSTAGRAM_CLIENT_ID, @"client_id",
                                   INSTAGRAM_CLIENT_SECRET, @"client_secret",
                                   nil];
        
        [manager POST:@"https://api.instagram.com/oauth/access_token"
           parameters:parametersDictionary
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  accessToken.token = [responseObject objectForKey:@"access_token"];
                  NSLog(@"access_token = %@", [responseObject objectForKey:@"access_token"]);
                  
                  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                  
                  NSString* url = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/rustic_world/media/recent?access_token=%@", accessToken.token];
                  
                  [manager GET:url
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          // NSLog(@"JSON: %@", responseObject);
                           NSArray *data = [responseObject objectForKey:@"data"];
                           
                           for (NSDictionary *dict in data) {
//                               STPosts *post = [[STPosts alloc] initWithServerResponse:dict];
                            //   NSLog(@"id = %@  text = %@", post.id, post.text);
                               
                           }
                           
                           //NSDictionary *obj = [data objectAtIndex:0];
                           
                           
//                           //NSDictionary *caption = [obj objectForKey:@"caption"];
//                           NSString *text = [[obj objectForKey:@"caption"] objectForKey:@"text"];
//                           NSLog(@"%@", text);
//                           
//                           NSString *id = [[obj objectForKey:@"caption"] objectForKey:@"id"];
//                           
//                           
//                           NSDictionary *images = [obj objectForKey:@"images"];
//                           
//                           //NSDictionary *low_resolution = ;
//
//                           
//                           NSURL* urlString = [[images objectForKey:@"low_resolution"] objectForKey:@"url"];
//                           
//                           
//                           
//                           NSLog(@"%@ %@", id, [NSString stringWithFormat:@"%@", urlString]);
    
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Error: %@", error);
                  }];
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
        }];
        
        if (self.completionBlock) {
            self.completionBlock(accessToken);
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        return NO;
    }
    return YES;
}

@end
