//
//  STTableViewCell.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STTableViewCell.h"

NSString *const STTableViewCellIdentifier = @"STTableViewCellIdentifier";

@interface STTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *contentImage;
@property (nonatomic, weak) IBOutlet UILabel *contentText;

@end

@implementation STTableViewCell

//- (void)setContent:(MSContent *)content {
//    self.contentText.text = content.text;
//    self.contentImage.image = [UIImage imageNamed:content.imageName];
//}

@end
