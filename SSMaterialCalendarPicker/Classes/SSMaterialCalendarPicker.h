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

@interface SSMaterialCalendarPicker : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SSCalendarCollectionViewCellDelegate>

@property (strong, nonatomic) id<SSMaterialCalendarPickerDelegate> delegate;
@property (strong, nonatomic) NSArray *disabledDates;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

+ (void)showCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate;
+ (SSMaterialCalendarPicker *)initCalendarOn:(UIView *)view withDelegate:(id<SSMaterialCalendarPickerDelegate>)delegate;
- (void)showAnimated;
- (void)closeAnimated;

@end

@protocol SSMaterialCalendarPickerDelegate <NSObject>

- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
