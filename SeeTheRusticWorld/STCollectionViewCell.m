//
//  STCollectionViewCell.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STCollectionViewCell.h"
#import "STPost.h"
#import "UIImageView+AFNetworking.h"

NSString *const STCollectionViewCellIdentifier = @"STCollectionViewCellIdentifier";

@interface STCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *contentImage;

@end

@implementation STCollectionViewCell

- (void)setContent:(STPost *)content {    
    NSURL *url = [NSURL URLWithString:content.imageUrlString];
    [self.contentImage setImageWithURL:url];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.contentImage.image = nil;
    [self.contentImage cancelImageRequestOperation];
}

@end
