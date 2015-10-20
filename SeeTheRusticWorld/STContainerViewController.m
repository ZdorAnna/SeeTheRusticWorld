//
//  STContainerViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STContainerViewController.h"
#import "STCollectionViewController.h"
#import "STTableViewController.h"

NSString *const STContainerViewControllerIdentifier = @"STContainerViewControllerIdentifier";

@interface STContainerViewController ()

@property (nonatomic, strong) UIViewController *collectionViewController;
@property (nonatomic, strong) UIViewController *tableViewController;
@property (nonatomic, assign) BOOL isTableViewControllerVisible;

@end

@implementation STContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:STTableViewControllerIdentifier];
    self.isTableViewControllerVisible = YES;
    [self displayViewController:self.tableViewController];
}

#pragma mark - Methods

- (void) displayViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)changeFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    toViewController.view.frame = [self frameForContentController];
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    static const NSTimeInterval kControllersSwitchingAnimationDuration = 0.3;
    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:kControllersSwitchingAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished) {
                                [fromViewController removeFromParentViewController];
                                [toViewController didMoveToParentViewController:self];
                            }];
}

- (void)changeController {
    if (self.isTableViewControllerVisible) {
        self.collectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:
                                         STCollectionViewControllerIdentifier];
        [self changeFromViewController:self.tableViewController toViewController:self.collectionViewController];
        self.isTableViewControllerVisible = NO;
    } else {
        self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:
                                    STTableViewControllerIdentifier];
        [self changeFromViewController:self.collectionViewController toViewController:self.tableViewController];
        self.isTableViewControllerVisible = YES;
    }
}

- (CGRect)frameForContentController {
    return self.view.bounds;
}
@end
