//
//  ViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STTableViewController.h"
#import "STTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "STDataSource.h"

NSString *const STTableViewControllerIdentifier = @"STTableViewControllerIdentifier";

@interface STTableViewController () <UITableViewDataSource>

@end

@implementation STTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[STDataSource alloc] init];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   // return [self.dataSource contentCount];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    [cell setContent:[self.dataSource contentAtIndexPath:indexPath]];
/*
    NSURL *url = [NSURL URLWithString:@"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s320x320/e35/12142039_533666396796116_873267970_n.jpg"];
    
     NSURLRequest* request = [NSURLRequest requestWithURL:url];
    __weak UITableViewCell* weakCell = cell;
    [cell.imageView
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
       weakCell.imageView.image = image;
         [weakCell layoutSubviews];
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         
     }];
 */
    
    return cell;
}

@end
