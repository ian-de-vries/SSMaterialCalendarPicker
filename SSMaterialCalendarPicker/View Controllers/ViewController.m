//
//  ViewController.m
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import "ViewController.h"
#import "NSDate+SSDateAdditions.h"

#define kCalendarCellIdentifier @"SSCalendarCollectionViewCell"

@implementation ViewController {
    NSMutableArray *dates;
}

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDates];
    [self.calendarCollectionView setAllowsMultipleSelection:YES];
}

- (void)initializeDates {
    dates = [[NSMutableArray alloc] init];
    for (int i = 0; i < 30; i++) {
        [dates addObject:[NSDate daysFromNow:i]];
    }
}

#pragma mark - UICollectionView Delegate & DataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellIdentifier forIndexPath:indexPath];
    [calendarCell setCellDate:[dates objectAtIndex:indexPath.row]];
    [calendarCell setDelegate:self];
    [calendarCell calendarCellSetup];
    [calendarCell setSelected:[self shouldSelect:calendarCell]];
    return calendarCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dates.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell = (SSCalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.startDate == nil) self.startDate = calendarCell.cellDate;
    else if (self.endDate == nil) self.endDate = calendarCell.cellDate;
    else if ([calendarCell.cellDate compare:self.startDate] == NSOrderedAscending) self.startDate = calendarCell.cellDate;
    else if ([calendarCell.cellDate compare:self.endDate] == NSOrderedDescending) self.endDate = calendarCell.cellDate;
    [self refreshVisible];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell = (SSCalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([calendarCell.cellDate compare:self.startDate] == NSOrderedSame) self.startDate = nil;
    if ([calendarCell.cellDate compare:self.endDate] == NSOrderedSame) self.endDate = nil;
    [self refreshVisible];
}

- (void)refreshVisible {
    NSArray *visibleCells = [self.calendarCollectionView visibleCells];
    for (SSCalendarCollectionViewCell *calendarCell in visibleCells)
        [calendarCell setSelected:[self shouldSelect:calendarCell]];
}

- (BOOL)shouldSelect:(SSCalendarCollectionViewCell *)calendarCell {
    if (self.startDate != nil && self.endDate != nil)
        return [calendarCell.cellDate isDateBetween:self.startDate and:self.endDate];
    else return ([calendarCell.cellDate isEqualToDate:self.startDate] || [calendarCell.cellDate isEqualToDate:self.endDate]);
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
