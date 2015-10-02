//
//  STServerManager.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STServerManager.h"

@implementation STServerManager

+ (STServerManager *)sharedManager {
    static STServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STServerManager alloc] init];
    });
    
    return manager;
}

@end
