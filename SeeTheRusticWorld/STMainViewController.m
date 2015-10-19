//
//  STMainViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STMainViewController.h"
#import "STContainerViewController.h"
#import "STServerManager.h"

static NSString *const STEmbedContainer = @"STEmbedContainer";

@interface STMainViewController ()

@property (nonatomic, strong) STContainerViewController *containerViewController;
@property (nonatomic, assign) BOOL firstTimeAppear;

@end

@implementation STMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstTimeAppear = YES;

   }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        [[STServerManager sharedManager] authorizeUser];
    }
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
