//
//  STPost.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/20/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STPost : NSManagedObject

@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSString * identifier;
#warning из имени свойства моет показаться, что оно типа NSURL, но это не так. переименуйте свойство
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * text;

@end
