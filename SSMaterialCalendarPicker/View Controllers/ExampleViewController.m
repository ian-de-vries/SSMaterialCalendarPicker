//
//  ViewController.m
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import "ExampleViewController.h"
#import "SSMaterialCalendarPicker.h"

@implementation ExampleViewController {
    SSMaterialCalendarPicker *datePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatePicker];
}

- (void)initDatePicker {
    datePicker = [SSMaterialCalendarPicker initCalendarOn:self.view withDelegate:self];
}

- (IBAction)showCalendar:(id)sender {
    [datePicker showAnimated];
}

- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSLog(@"startDate: %@\nendDate: %@", startDate, endDate);
}

@end
