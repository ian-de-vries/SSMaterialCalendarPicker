//
//  ViewController.h
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSCalendarCollectionViewCell.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, SSCalendarCollectionViewCellDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *calendarCollectionView;

@end

