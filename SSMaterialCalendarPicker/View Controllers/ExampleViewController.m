//
//  ViewController.m
//  SSMaterialDateRangeSelector
//
//  Created by Iuri Chiba on 7/15/15.
//  Copyright (c) 2015 Shoryuken Solutions. All rights reserved.
//

#import "ExampleViewController.h"
#import "SSMaterialCalendarPicker.h"

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showCalendar:(id)sender {
    [SSMaterialCalendarPicker showCalendarOn:self.view];
}

@end
