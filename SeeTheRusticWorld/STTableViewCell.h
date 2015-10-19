//
//  STTableViewCell.h
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STPost;
extern NSString *const STTableViewCellIdentifier;

@interface STTableViewCell : UITableViewCell

- (void)setContent:(STPost *)content;

@end
