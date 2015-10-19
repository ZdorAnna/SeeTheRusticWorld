//
//  STCollectionViewCell.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STCollectionViewCell.h"
#import "STPost.h"

NSString *const STCollectionViewCellIdentifier = @"STCollectionViewCellIdentifier";

@interface STCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *contentImage;

@end

@implementation STCollectionViewCell

//- (void)setPost:(STPost *)content {
//    self.contentImage.image = [UIImage imageNamed:content.imageName];
//}

@end
