//
//  STTableViewCell.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STTableViewCell.h"
#import "STPost.h"
#import "UIImageView+AFNetworking.h"


NSString *const STTableViewCellIdentifier = @"STTableViewCellIdentifier";

@interface STTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *contentImage;
@property (nonatomic, weak) IBOutlet UILabel *contentText;

@end

@implementation STTableViewCell

- (void)setContent:(STPost *)content {
    
    self.contentText.text = content.text;
    NSURL *url = [NSURL URLWithString:content.imageUrlString];
    [self.contentImage setImageWithURL:url];
}

@end
