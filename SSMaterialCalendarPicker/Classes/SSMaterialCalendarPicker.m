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

#define kCalendarHeaderHeight 72.0f
#define kPickerViewHeight 351.0f

#define kAlphaShow 1.0f
#define kAlphaHide 0.0f

@interface SSMaterialCalendarPicker ()

#pragma mark - Private Outlets
#pragma mark Customizable
@property (weak, nonatomic) IBOutlet UILabel *calendarTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *statusBarHeader;
@property (weak, nonatomic) IBOutlet UIView *calendarHeader;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator;
@property (weak, nonatomic) IBOutlet UIButton *upArrow;
@property (weak, nonatomic) IBOutlet UIButton *downArrow;

#pragma mark Needed for Animations
@property (weak, nonatomic) IBOutlet UIControl *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *calendarContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewTopDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeaderTopDistance;

#pragma mark Data Source & Ever-changing Content
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *headerCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;

#pragma mark Warnings
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *warningMessage;

#pragma mark Show/Init Control
@property (nonatomic) BOOL shouldRemove;

@end

#pragma mark -
#pragma mark -
@implementation SSMaterialCalendarPicker {
#pragma mark - Control Variables
    NSMutableArray *dates;
    NSDate *selectedMonth;
    BOOL runningScrollAnimation;
    NSIndexPath *blinkIndexPath;
    CGFloat lastOffset;
    BOOL init;
}

#pragma mark - Show Calendar
+ (void)showCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate {
    SSMaterialCalendarPicker *picker = [[self alloc] initWithFrame:view.frame];
    [picker.headerCollectionViewHeight setConstant:CGRectGetWidth(view.frame)/7.0001f];
    [picker setDelegate:delegate];
    [view addSubview:picker];
    [picker setShouldRemove:YES];
    [picker showAnimated];
}

+ (SSMaterialCalendarPicker *)initCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate {
    SSMaterialCalendarPicker *picker = [[self alloc] initWithFrame:view.frame];
    [picker.headerCollectionViewHeight setConstant:CGRectGetWidth(view.frame)/7];
    [picker setDelegate:delegate];
    [view addSubview:picker];
    return picker;
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UINib *cellNib = [UINib nibWithNibName:kCalendarCellIdentifier bundle:[NSBundle bundleForClass:[SSCalendarCollectionViewCell class]]];
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:kCalendarPickerIdentifier
                                                               owner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
        [self initializeDates];
        [self addCalendarMask];
        [self.calendarCollectionView setAllowsMultipleSelection:YES];
        [self.calendarCollectionView setMultipleTouchEnabled:NO];
        [self.calendarCollectionView registerNib:cellNib forCellWithReuseIdentifier:kCalendarCellIdentifier];
        [self.headerCollectionView registerNib:cellNib forCellWithReuseIdentifier:kCalendarCellIdentifier];
        [(UICollectionViewFlowLayout *)self.headerCollectionView.collectionViewLayout setMinimumInteritemSpacing:0];
        [(UICollectionViewFlowLayout *)self.headerCollectionView.collectionViewLayout setMinimumLineSpacing:0];
        [(UICollectionViewFlowLayout *)self.calendarCollectionView.collectionViewLayout setMinimumInteritemSpacing:0];
        [(UICollectionViewFlowLayout *)self.calendarCollectionView.collectionViewLayout setMinimumLineSpacing:0];
        [self setMultipleTouchEnabled:NO];
        [self.backgroundView addTarget:self action:@selector(closeAnimated) forControlEvents:UIControlEventTouchUpInside];
    } return self;
}

- (void)initializeDates {
    [self setMonthFromDate:[NSDate date].firstDayOfTheMonth.defaultTime];
    if (self.disabledDates == nil) self.disabledDates = [[NSArray alloc] init];

    dates = [[NSMutableArray alloc] init];
    
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|
                               NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
                               NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:[NSDate date]];
    comps.year--;
    NSDate *oneYearAgo = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    for (int i = 0; i < 372; i++) {
        [dates addObject:[NSDate days:i fromDate:oneYearAgo].defaultTime];
    }
    
    self.startDate = self.startDate.defaultTime;
    self.endDate = self.endDate.defaultTime;
}

- (void)addCalendarMask {
//    if (self.calendarContainer.layer.mask == nil) {
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.calendarContainer.bounds;
//        gradient.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
//        gradient.locations = @[@0.86f, @0.96f];
//        self.calendarContainer.layer.mask = gradient;
//    }
}

- (void)removeCalendarMask {
    if (self.calendarContainer.layer.mask != nil)
        self.calendarContainer.layer.mask = nil;
}

- (void)setForceLocale:(NSLocale *)newForceLocale {
    _forceLocale = newForceLocale;
    [self setMonthFromDate:[NSDate date].firstDayOfTheMonth.defaultTime];
}

- (void)setCalendarTitle:(NSString *)newCalendarTitle {
    _calendarTitle = newCalendarTitle;
    self.calendarTitleLabel.text = _calendarTitle;
}

- (void)setPrimaryColor:(UIColor *)newPrimaryColor {
    _primaryColor = newPrimaryColor;
    [self.calendarHeader setBackgroundColor:_primaryColor];
    [self.upArrow setTitleColor:_primaryColor forState:UIControlStateNormal];
    [self.downArrow setTitleColor:_primaryColor forState:UIControlStateNormal];
}

- (void)setSecondaryColor:(UIColor *)newSecondaryColor {
    _secondaryColor = newSecondaryColor;
    [self.statusBarHeader setBackgroundColor:_secondaryColor];
    [self.headerSeparator setBackgroundColor:_secondaryColor];
}

- (void)setSingleDateMode:(BOOL)singleDateMode {
    _singleDateMode = singleDateMode;
    if (singleDateMode) self.okButton.hidden = YES;
    else self.okButton.hidden = NO;
}

- (void)setOkButtonText:(NSString *)okButtonText {
    _okButtonText = okButtonText;
    [self.okButton setTitle:okButtonText forState:UIControlStateNormal];
}

#pragma mark - Open/Close Calendar
- (void)showAnimated {
    self.hidden = NO;
    [UIView animateWithDuration:0.1f animations:^{
        self.backgroundView.alpha = kAlphaShow;
//        self.pickerViewTopDistance.constant = kCalendarHeaderHeight;
//        self.calendarHeaderTopDistance.constant = 0.0f;
//        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self refreshVisible];
        CGPoint bottomOffset = CGPointMake(0, self.calendarCollectionView.contentSize.height - self.calendarCollectionView.bounds.size.height);
        [self.calendarCollectionView setContentOffset:bottomOffset animated:YES];
        
    }];
}

- (void)closeAnimated {
    [UIView animateWithDuration:0.6f animations:^{
        self.backgroundView.alpha = kAlphaHide;
        self.pickerViewTopDistance.constant = -kPickerViewHeight-16;
        self.calendarHeaderTopDistance.constant = -kCalendarHeaderHeight-16;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (self.shouldRemove)
            [self removeFromSuperview];
    }];
}

- (void)resetDates {
    self.startDate = nil;
    self.endDate = nil;
    [self.calendarCollectionView reloadData];
}

#pragma mark - Date Selected
- (IBAction)okClicked {
    if (self.startDate != nil && self.endDate != nil)
        [self.delegate rangeSelectedWithStartDate:self.startDate andEndDate:self.endDate];
    else if (self.startDate != nil && self.endDate == nil)
        [self.delegate rangeSelectedWithStartDate:self.startDate andEndDate:self.startDate];
    else if (self.startDate == nil && self.endDate != nil)
        [self.delegate rangeSelectedWithStartDate:self.endDate andEndDate:self.endDate];
    [self closeAnimated];
}

#pragma mark - UICollectionView Delegate & DataSource
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < lastOffset - 100 ||
        scrollView.contentOffset.y > lastOffset + 100) {
        lastOffset = scrollView.contentOffset.y;
        if (!runningScrollAnimation)
            [self checkVisibleMonth];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView {
    [self checkVisibleMonth];
    runningScrollAnimation = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellIdentifier forIndexPath:indexPath];
    if (collectionView == self.headerCollectionView) [calendarCell setHeaderMode:YES];
    [calendarCell setCellDate:[dates objectAtIndex:indexPath.row]];
    [calendarCell setPrimaryColor:self.primaryColor];
    [calendarCell setSecondaryColor:self.secondaryColor];
    [calendarCell setForceLocale:self.forceLocale];
    [calendarCell setDelegate:self];
    [calendarCell calendarCellSetup];
    [calendarCell fastSelectCalendarCell:[self shouldSelect:calendarCell]];
    [calendarCell disableCalendarCell:[self shouldDisable:calendarCell]];
    
    if (blinkIndexPath != nil && indexPath.row == blinkIndexPath.row) {
        [calendarCell blink];
        blinkIndexPath = nil;
    }
    
    return calendarCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SSCalendarCollectionViewCell *calendarCell = [self cellAtIndexPath:indexPath];
    if (self.singleDateMode) {
        self.startDate = calendarCell.cellDate;
        self.endDate = calendarCell.cellDate;
        [self.delegate rangeSelectedWithStartDate:calendarCell.cellDate andEndDate:calendarCell.cellDate];
        [self closeAnimated];
    } if (!calendarCell.isDisabled) {
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
    SSCalendarCollectionViewCell *calendarCell = [self cellAtIndexPath:indexPath];
    if (self.singleDateMode) {
        self.startDate = calendarCell.cellDate;
        self.endDate = calendarCell.cellDate;
        [self.delegate rangeSelectedWithStartDate:calendarCell.cellDate andEndDate:calendarCell.cellDate];
        [self closeAnimated];
    } if (!calendarCell.isDisabled) {
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
    CGFloat size = CGRectGetWidth(collectionView.frame)/7.001f;
    return CGSizeMake(size, size);
}

#pragma mark - Month Control
- (void)setMonthFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM, YYYY"];
    if (self.forceLocale != nil) [formatter setLocale:self.forceLocale];
    [self.monthLabel setText:[formatter stringFromDate:date].capitalizedString];
    selectedMonth = date;
}

- (void)checkVisibleMonth {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        CGFloat cellSize = CGRectGetWidth(self.calendarCollectionView.frame)/7.001f;
        NSIndexPath *indexPath = [self.calendarCollectionView indexPathForItemAtPoint:[[self.calendarCollectionView superview]
                                                                                       convertPoint:CGPointMake(cellSize/2 + i*cellSize, cellSize/2)
                                                                                       toView:self.calendarCollectionView]];
        if (indexPath != nil)
            [indexPaths addObject:indexPath];
    };
    
    if (indexPaths.count > 0) {
        BOOL monthChanged = NO;
        for (NSIndexPath *indexPath in [indexPaths subarrayWithRange:NSMakeRange(0, MIN(indexPaths.count, 7))]) {
            SSCalendarCollectionViewCell *cell = [self cellAtIndexPath:indexPath];
            if (cell == nil) return;
            NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:cell.cellDate];
            if (day == 1) {
                [self setMonthFromDate:cell.cellDate];
                monthChanged = YES;
            } if (cell.cellDate == [NSDate date].firstDayOfTheMonth.defaultTime) {
                [self setMonthFromDate:cell.cellDate];
                monthChanged = YES; break;
            }
        } if (!monthChanged)
            [self setMonthFromDate:[self cellAtIndexPath:indexPaths.firstObject].cellDate.firstDayOfTheMonth];
    }
}

- (IBAction)previousMonthButtonTapped:(id)sender {
    if (!runningScrollAnimation) {
        NSDate *newDate = [selectedMonth addMonths:-1].defaultTime;
        if ([dates containsObject:newDate])
            [self scrollToMonthWithDate:newDate];
        else if ([dates indexOfObject:dates] > 0)
            [self.calendarCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (IBAction)nextMonthButtonTapped:(id)sender {
    if (!runningScrollAnimation) {
        NSDate *newDate = [selectedMonth addMonths:1].defaultTime;
        if ([dates containsObject:newDate])
            [self scrollToMonthWithDate:newDate];
    }
}

- (void)scrollToMonthWithDate:(NSDate *)date {
    runningScrollAnimation = YES;
    NSInteger row = [self findRowWithDate:date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.calendarCollectionView layoutAttributesForItemAtIndexPath:indexPath];
    [self.calendarCollectionView setContentOffset:CGPointMake(0, CGRectGetMinY(attributes.frame)-8) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SSCalendarCollectionViewCell *cell = [self cellAtIndexPath:indexPath];
        if (cell == nil)
            blinkIndexPath = indexPath;
        else [cell blink];
    });
}

#pragma mark - Calendar Cells Control
- (SSCalendarCollectionViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    return (SSCalendarCollectionViewCell *)[self.calendarCollectionView cellForItemAtIndexPath:indexPath];
}

- (NSInteger)findRowWithDate:(NSDate *)targetDate {
    NSDate *firstDate = dates.firstObject;
    return [NSDate daysBetween:firstDate and:targetDate];
}

- (NSDate *)shouldReplace:(NSDate *)date {
    NSTimeInterval start = fabs([date timeIntervalSinceDate:self.startDate]);
    NSTimeInterval end = fabs([date timeIntervalSinceDate:self.endDate]);
    if (start < end) return self.startDate;
    else return self.endDate;
}

- (BOOL)shouldSelect:(SSCalendarCollectionViewCell *)calendarCell {
    if (self.singleDateMode) {
        return ([calendarCell.cellDate isEqualToDate:self.startDate] || [calendarCell.cellDate isEqualToDate:self.endDate]);
    } if (self.startDate != nil && self.endDate != nil)
        return [calendarCell.cellDate isDateBetween:self.startDate and:self.endDate];
    else return ([calendarCell.cellDate isEqualToDate:self.startDate] || [calendarCell.cellDate isEqualToDate:self.endDate]);
}

- (BOOL)shouldDisable:(SSCalendarCollectionViewCell *)calendarCell {
    if ([[NSDate date].defaultTime compare:calendarCell.cellDate] == NSOrderedAscending) return YES;
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
            [self showWarning:self.disabledIntervalWarning == nil? @"WARNING: Interval unavailable!":self.disabledIntervalWarning];
            self.startDate = startBackup;
            self.endDate = endBackup;
            break;
        }
    }
}

- (void)refreshVisible {
    NSArray *visibleCells = [self.calendarCollectionView visibleCells];
    if (!init) {
        for (SSCalendarCollectionViewCell *calendarCell in visibleCells) {
            [calendarCell fastSelectCalendarCell:[self shouldSelect:calendarCell]];
            [calendarCell fastDisableCalendarCell:[self shouldDisable:calendarCell]];
        } init = YES;
    } else {
        for (SSCalendarCollectionViewCell *calendarCell in visibleCells) {
            [calendarCell selectCalendarCell:[self shouldSelect:calendarCell]];
            [calendarCell disableCalendarCell:[self shouldDisable:calendarCell]];
        }
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
