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
#define MIN_COUNT_CELLS 12

#warning как этот контроллер будет реагировать на изменения внутри выборки NSFetchedResultsController, если он не реализовал ниодного метода из протокола NSFetchedResultsControllerDelegate?
@interface STCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@end

@implementation STCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[STDataSource alloc] initWithDelegate:self];
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
#warning здесь такое же замечание, как и в табличном контроллере?
    if ([self.dataSource contentCount] >= MIN_COUNT_CELLS) {
        if (indexPath.row == ([self.dataSource contentCount] )){
            [self.dataSource loadNextPage];
        }
    }
}
@end
