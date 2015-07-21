//
//  SSMaterialCalendarPicker.h
//  SSMaterialCalendarPicker
//
//  Created by Iuri Chiba on 7/21/15.
//  Copyright © 2015 Shoryuken Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCalendarCollectionViewCell.h"

@interface SSMaterialCalendarPicker : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SSCalendarCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *headerCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *warningMessage;
@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;
@property (strong, nonatomic) NSArray *disabledDates;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

+ (void)showCalendarOn:(UIView *)view;

@end
