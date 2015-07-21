//
//  SSMaterialCalendarPicker.m
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/21/15.
//  Copyright © 2015 Shoryuken Solutions. All rights reserved.
//

#import "SSMaterialCalendarPicker.h"
#import "NSDate+SSDateAdditions.h"

#define kCalendarCellIdentifier @"SSCalendarCollectionViewCell"
#define kCalendarPickerIdentifier @"SSMaterialCalendarPicker"

@implementation SSMaterialCalendarPicker {
    NSMutableArray *dates;
}

#pragma mark - Show Calendar
+ (void)showCalendarOn:(UIView *)view {
    SSMaterialCalendarPicker *picker = [[self alloc] initWithFrame:view.frame];
    picker.headerCollectionViewHeight.constant = CGRectGetWidth(view.frame)/7;
    [view addSubview:picker];
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UINib *cellNib = [UINib nibWithNibName:kCalendarCellIdentifier bundle:nil];
        self = [[[NSBundle mainBundle] loadNibNamed:kCalendarPickerIdentifier
                                              owner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
        [self initializeDates];
        [self.calendarCollectionView setAllowsMultipleSelection:YES];
        [self.calendarCollectionView setMultipleTouchEnabled:NO];
        [self.calendarCollectionView registerNib:cellNib forCellWithReuseIdentifier:kCalendarCellIdentifier];
        [self.headerCollectionView registerNib:cellNib forCellWithReuseIdentifier:kCalendarCellIdentifier];
        [self setMultipleTouchEnabled:NO];
    } return self;
}

- (void)initializeDates {
    if (self.disabledDates == nil) self.disabledDates = [[NSArray alloc] init];
    int lastSunday = [NSDate daysFromLastSunday];
    dates = [[NSMutableArray alloc] init];
    for (int i = -lastSunday; i < 364-lastSunday; i++) {
        [dates addObject:[NSDate daysFromNow:i].defaultTime];
    } self.startDate = self.startDate.defaultTime;
    self.endDate = self.endDate.defaultTime;
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellIdentifier forIndexPath:indexPath];
    if (collectionView == self.headerCollectionView) [calendarCell setHeaderMode:YES];
    [calendarCell setCellDate:[dates objectAtIndex:indexPath.row]];
    [calendarCell setDelegate:self];
    [calendarCell calendarCellSetup];
    [calendarCell selectCalendarCell:[self shouldSelect:calendarCell]];
    [calendarCell disableCalendarCell:[self shouldDisable:calendarCell]];
    return calendarCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell = (SSCalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!calendarCell.isDisabled) {
        NSDate *startBackup = self.startDate;
        NSDate *endBackup = self.endDate;
        
        if (self.startDate == nil) self.startDate = calendarCell.cellDate;
        else if (self.endDate == nil) self.endDate = calendarCell.cellDate;
        else if ([calendarCell.cellDate compare:self.startDate] == NSOrderedAscending) self.startDate = calendarCell.cellDate;
        else if ([calendarCell.cellDate compare:self.endDate] == NSOrderedDescending) self.endDate = calendarCell.cellDate;
        [self checkReverse];
        [self checkDisabledRangeWithBackupStartDate:startBackup andEndDate:endBackup];
        [self refreshVisible];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell = (SSCalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!calendarCell.isDisabled) {
        if (self.startDate != nil && [calendarCell.cellDate compare:self.startDate] == NSOrderedSame) self.startDate = nil;
        else if (self.endDate != nil && [calendarCell.cellDate compare:self.endDate] == NSOrderedSame) self.endDate = nil;
        else {
            NSDate *replace = [self shouldReplace:calendarCell.cellDate];
            if (replace == self.startDate) self.startDate = calendarCell.cellDate;
            if (replace == self.endDate) self.endDate = calendarCell.cellDate;
        } [self refreshVisible];
    }
}

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat size = CGRectGetWidth(collectionView.frame)/7;
    return CGSizeMake(size, size);
}

#pragma mark - Calendar Cells Control
- (NSDate *)shouldReplace:(NSDate *)date {
    NSTimeInterval start = fabs([date timeIntervalSinceDate:self.startDate]);
    NSTimeInterval end = fabs([date timeIntervalSinceDate:self.endDate]);
    if (start < end) return self.startDate;
    else return self.endDate;
}

- (BOOL)shouldSelect:(SSCalendarCollectionViewCell *)calendarCell {
    if (self.startDate != nil && self.endDate != nil)
        return [calendarCell.cellDate isDateBetween:self.startDate and:self.endDate];
    else return ([calendarCell.cellDate isEqualToDate:self.startDate] || [calendarCell.cellDate isEqualToDate:self.endDate]);
}

- (BOOL)shouldDisable:(SSCalendarCollectionViewCell *)calendarCell {
    if ([[NSDate date].defaultTime compare:calendarCell.cellDate] == NSOrderedDescending) return YES;
    if ([self isDateDisabled:calendarCell.cellDate]) return YES;
    return NO;
}

- (void)checkReverse {
    if (self.startDate != nil && self.endDate != nil
        && [self.startDate compare:self.endDate] == NSOrderedDescending) {
        NSDate *temp = self.startDate;
        self.startDate = self.endDate;
        self.endDate = temp;
    }
}

- (BOOL)isDateDisabled:(NSDate *)date {
    BOOL disabled = NO;
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate.defaultTime compare:date.defaultTime] == NSOrderedSame) disabled = YES;
    } return disabled;
}

- (void)checkDisabledRangeWithBackupStartDate:(NSDate *)startBackup andEndDate:(NSDate *)endBackup {
    for (int i = 1; i < [NSDate daysBetween:self.startDate and:self.endDate]; i++) {
        if ([self isDateDisabled:[self.startDate addDays:i]]) {
            [self showWarning:@"Existem datas bloqueadas nesse intervalo!"];
            self.startDate = startBackup;
            self.endDate = endBackup;
            break;
        }
    }
}

- (void)refreshVisible {
    NSArray *visibleCells = [self.calendarCollectionView visibleCells];
    for (SSCalendarCollectionViewCell *calendarCell in visibleCells) {
        [calendarCell selectCalendarCell:[self shouldSelect:calendarCell]];
        [calendarCell disableCalendarCell:[self shouldDisable:calendarCell]];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.calendarCollectionView.isDragging || self.calendarCollectionView.isDecelerating) {
        return self.calendarCollectionView;
    } return [super hitTest:point withEvent:event];
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

#pragma mark - Warning Control
- (void)showWarning:(NSString *)message {
    _warningMessage.text = message;
    [UIView animateWithDuration:0.3f animations:^{
        _warningViewHeight.constant = 28.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                _warningViewHeight.constant = 0.0f;
                [self layoutIfNeeded];
            }];
        });
    }];
}

@end
