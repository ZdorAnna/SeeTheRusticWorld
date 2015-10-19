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

- (STPost *)contentAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)contentCount;
//- (void)saveModelWithImageName:(NSString *)imageName text:(NSString *)text;

@end
