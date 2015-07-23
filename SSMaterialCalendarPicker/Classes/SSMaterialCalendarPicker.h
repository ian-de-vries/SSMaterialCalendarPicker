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
@property (strong, nonatomic) NSString *calendarTitle;
@property (weak, nonatomic) IBOutlet UILabel *calendarTitleLabel;
@property (strong, nonatomic) NSString *disabledIntervalWarning;

#pragma mark Interaction Properties:
@property (strong, nonatomic) id<SSMaterialCalendarPickerDelegate> delegate;
@property (strong, nonatomic) NSArray *disabledDates;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

#pragma mark Show/Hide:
+ (void)showCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate;
+ (SSMaterialCalendarPicker *)initCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate;
- (void)showAnimated;
- (void)closeAnimated;

#pragma mark Show warning from outside (for some reason):
- (void)showWarning:(NSString *)message;

@end

#pragma mark - Protocol Definition
@protocol SSMaterialCalendarPickerDelegate <NSObject>

- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
