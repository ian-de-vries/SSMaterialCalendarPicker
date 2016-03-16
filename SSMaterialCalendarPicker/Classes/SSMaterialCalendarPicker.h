//
//  SSMaterialCalendarPicker.h
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/21/15.
//  Copyright © 2015 Shoryuken Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCalendarCollectionViewCell.h"

@protocol SSMaterialCalendarPickerDelegate;

#pragma mark - Calendar Picker
@interface SSMaterialCalendarPicker : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SSCalendarCollectionViewCellDelegate>

#pragma mark Customization:
@property (strong, nonatomic) NSLocale *forceLocale;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) UIColor *secondaryColor;
// Default value is "Select an Interval"
@property (strong, nonatomic) NSString *calendarTitle;
// Default value is "WARNING: Interval unavailable!"
@property (strong, nonatomic) NSString *disabledIntervalWarning;
// Default value is "Apply"
@property (strong, nonatomic) NSString *okButtonText;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

#pragma mark Interaction Properties:
@property (strong, nonatomic) id<SSMaterialCalendarPickerDelegate> delegate;
@property (strong, nonatomic) NSArray *disabledDates;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) BOOL singleDateMode;

#pragma mark Show/Hide:
+ (void)showCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate;
+ (SSMaterialCalendarPicker *)initCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate;
- (void)showAnimated;
- (void)closeAnimated;
- (void)resetDates;

#pragma mark Show warning from outside (for some reason):
- (void)showWarning:(NSString *)message;

@end

#pragma mark - Protocol Definition
@protocol SSMaterialCalendarPickerDelegate <NSObject>

- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
