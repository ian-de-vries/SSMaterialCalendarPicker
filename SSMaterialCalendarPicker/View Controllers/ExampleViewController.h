//
//  ExampleViewController.h
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMaterialCalendarPicker.h"

@interface ExampleViewController : UIViewController <SSMaterialCalendarPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

- (IBAction)showCalendar:(id)sender;

@end
