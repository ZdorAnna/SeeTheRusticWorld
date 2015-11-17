//
//  STLoginViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/6/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STLoginViewController.h"
#import "STServerManager.h"
#import "STMainViewController.h"
#import "STDefines.h"

@interface STLoginViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation STLoginViewController

- (void)viewDidLoad {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:STInstagramTokenKey]) {
        [self displayContainerViewController];
        
    } else {
        [self authorize];
        [self.view addSubview:self.webView];
   }
}

- (void)authorize {
    NSURLRequest *request = [[STServerManager sharedManager] userAuthorizationRequest];
    [self.webView loadRequest:request];
}

- (void)displayContainerViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *nextVC  = [storyboard
                                 instantiateViewControllerWithIdentifier:STMainViewControllerIdentifier];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType {
        if ([[[request URL] description] rangeOfString:@"code="].location != NSNotFound) {
        
        NSString *authToken;
        NSString *query = [[request URL] description];
        NSArray *array = [query componentsSeparatedByString:@"?"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        NSArray *values = [query componentsSeparatedByString:@"="];
        if ([values count] == 2) {
            NSString *key = [values firstObject];
            
            if ([key isEqualToString:@"code"]) {
               authToken = [values lastObject];
            }
        }
        __weak typeof(self) weakSelf = self;

         [[STServerManager sharedManager] requestTokenWithCode:authToken onSuccess:^(NSString *accessToken) {
             [weakSelf displayContainerViewController];
         } onFailure:^(NSError *error, NSInteger statusCode) {
             NSLog(@"Error %@", error);
         }];
        
        return NO;
    }
    return YES;
}

@end
