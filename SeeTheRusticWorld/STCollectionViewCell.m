//
//  STCollectionViewCell.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STCollectionViewCell.h"

NSString *const STCollectionViewCellIdentifier = @"STCollectionViewCellIdentifier";

@interface STCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *contentImage;

@end

@implementation STCollectionViewCell

//- (void)setContent:(MSContent *)content {
//    self.contentImage.image = [UIImage imageNamed:content.imageName];
//}

@end
