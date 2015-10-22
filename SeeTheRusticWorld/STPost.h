//
//  STPost.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/22/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STPost : NSManagedObject

@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * imageUrlString;
@property (nonatomic, retain) NSString * text;

@end
