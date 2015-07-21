//
//  ViewController.h
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSCalendarCollectionViewCell.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SSCalendarCollectionViewCellDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *calendarCollectionView;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end

