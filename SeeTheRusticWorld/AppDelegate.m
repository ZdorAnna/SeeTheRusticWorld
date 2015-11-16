//
//  AppDelegate.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "AppDelegate.h"
#import "STCoreDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationWillTerminate:(UIApplication *)application {
    [[STCoreDataManager sharedManager] saveContext];
}

@end
