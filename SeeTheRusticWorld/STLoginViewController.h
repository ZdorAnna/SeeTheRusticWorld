//
//  STLoginViewController.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/6/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STAccessToken;

typedef void(^STLoginCompletionBlock)(STAccessToken *token);

@interface STLoginViewController : UIViewController <UIWebViewDelegate>

- (id)initWithCompletionBlock:(STLoginCompletionBlock)completionBlock;

@end
