//
//  STCollectionViewController.m
//  SeeTheRusticWorld
//
//  Created by anna on 10/2/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

#import "STCollectionViewController.h"
#import "STCollectionViewCell.h"
#import "STDataSource.h"


NSString *const STCollectionViewControllerIdentifier = @"STCollectionViewControllerIdentifier";

@interface STCollectionViewController ()

@end

@implementation STCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[STDataSource alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.dataSource loadNextPage];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource contentCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:STCollectionViewCellIdentifier
                                                                           forIndexPath:indexPath];
    [cell setContent:[self.dataSource contentAtIndexPath:indexPath]];
    return cell;
}

@end
