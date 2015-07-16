//
//  ViewController.m
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import "ViewController.h"

#define kCalendarCellIdentifier @"SSCalendarCollectionViewCell"

@implementation ViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UICollectionView Delegate & DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellIdentifier
                                              forIndexPath:indexPath];
    calendarCell.delegate = self;
    return calendarCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @"Selected!");
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @"Deselected!");
}

#pragma mark - SSCalendarCollectionViewCell Delegate
- (void)cellClicked:(SSCalendarCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.calendarCollectionView indexPathForCell:cell];
    if (!cell.isSelected) {
        [self.calendarCollectionView selectItemAtIndexPath:indexPath animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.calendarCollectionView didSelectItemAtIndexPath:indexPath];
    } else  {
        [self.calendarCollectionView deselectItemAtIndexPath:indexPath animated:NO];
        [self collectionView:self.calendarCollectionView didDeselectItemAtIndexPath:indexPath];
    }
}

@end
