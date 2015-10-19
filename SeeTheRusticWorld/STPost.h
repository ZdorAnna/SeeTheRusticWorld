//
//  STPosts.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/17/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STPost : NSManagedObject

@property (nonatomic) NSTimeInterval createdTime;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * text;

@end
