//
//  STServerManager.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STServerManager : NSObject

+ (STServerManager *)sharedManager;
- (NSURLRequest *)userAuthorizationRequest;
- (void)authorizeUser;

@end
