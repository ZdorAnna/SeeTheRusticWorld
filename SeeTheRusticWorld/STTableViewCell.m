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
    
   // self.contentImage.image = [UIImage imageNamed:content.imageName];
    
    [self.contentImage.image
     setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:content.imageURL]]
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        // weakCell.contentImage.image = image;
         //[self layoutSubviews];
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         
     }];
}

@end
