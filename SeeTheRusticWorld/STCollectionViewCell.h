//
//  STCollectionViewCell.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STPost;

extern NSString *const STCollectionViewCellIdentifier;

@interface STCollectionViewCell : UICollectionViewCell

- (void)setContent:(STPost *)content;

@end
