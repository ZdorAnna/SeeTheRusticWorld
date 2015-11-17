//
//  STDataSource.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/14/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPost;

@interface STDataSource : NSObject

- (instancetype)initWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;
- (STPost *)contentAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)contentCount;
- (void)loadNextPage;

@end
