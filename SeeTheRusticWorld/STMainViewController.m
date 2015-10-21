//
//  STMainViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STMainViewController.h"
#import "STContainerViewController.h"
#import "STLoginViewController.h"

static NSString *const STEmbedContainer = @"STEmbedContainer";
NSString *const STMainViewControllerIdentifier = @"STMainViewControllerIdentifier";

@interface STMainViewController ()

@property (nonatomic, strong) STContainerViewController *containerViewController;

@end

@implementation STMainViewController

#warning в следующих двух методах нет необходимости
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:STEmbedContainer]) {
        self.containerViewController = segue.destinationViewController;
    }
}

#pragma mark - Actions

- (IBAction)actionChangeView:(UIBarButtonItem *)sender {
    [self.containerViewController changeController];
}

@end
