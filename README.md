![Shoryuken Solutions Logo](http://i.imgur.com/hBbIN4k.png "Shoryuken Solutions")



##**SSMaterialCalendarPicker**##
****************************
A lightly-customizable calendar pop-up view for range selection inspired by Google's Material Design Guidelines and apps.

Tested on iOS8 and iOS9. Supports **ONLY** portrait orientation, atm.


##Installation##
****************
I'm preparing this component to be listed as a pod for CocoaPods.  
Installation should be as follows, adding this line to your Podfile:

```
#!Ruby

pod 'SSMaterialCalendarPicker'
```

##Usage##
*********
Usage is really simple.  
1. Instantiate a SSMaterialCalendarPicker object on your View Controller:

```
#!Objective-C
// Add it on the keyWindow if you're using an UINavigationBar
datePicker = [SSMaterialCalendarPicker initCalendarOn:[UIApplication sharedApplication].keyWindow withDelegate:self];

// If there's a fullscreen view, add it there
datePicker = [SSMaterialCalendarPicker initCalendarOn:self.view withDelegate:self];
```
2. Customize it as you wish:

```
#!Objective-C
// Set a Locale if you want to force the localization - otherwise, it uses the device's default locale
datePicker.forceLocale = [NSLocale localeWithLocaleIdentifier:@"pt_BR"];

// Set a warning message for disabled intervals. Default is "WARNING: Interval unavailable!"
datePicker.disabledIntervalWarning = @"Anfitrião indisponível neste período!";

// Set a calendar title. Default is "Select an Interval"
datePicker.calendarTitle = @"Selecione um Período";

// Set a primary and a secondary color
datePicker.primaryColor = [UIColor colorWithRed:255/255.0f green:87/255.0f blue:34/255.0f alpha:1.0f];
datePicker.secondaryColor = [UIColor colorWithRed:244/255.0f green:81/255.0f blue:30/255.0f alpha:1.0f];

// Set disabled dates. Dates previous to the current date are disabled by default.
datePicker.disabledDates = @[[NSDate daysFromNow:arc4random_uniform(300)], [NSDate daysFromNow:arc4random_uniform(300)]];
```