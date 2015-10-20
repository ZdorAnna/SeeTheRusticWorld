//
//  STCollectionViewController.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STDataSource;

extern NSString *const STCollectionViewControllerIdentifier;

@interface STCollectionViewController : UICollectionViewController

@property (nonatomic, strong) STDataSource *dataSource;

@end
