![Shoryuken Solutions Logo](http://i.imgur.com/h2kNho0.png)



##**SSMaterialCalendarPicker**##
A lightly-customizable calendar pop-up view for range selection inspired by Google's Material Design Guidelines and apps.

Tested on iOS8 and iOS9. Supports **ONLY** portrait orientation, atm.

##Demo##
![Demo](http://i.imgur.com/30Eivbn.gif)

##Installation##
I'm preparing this component to be listed as a pod for CocoaPods.  
Installation should be as follows, adding this line to your Podfile:

```
#!Ruby

pod 'SSMaterialCalendarPicker'
```

##Usage##
Usage is really simple!

* Instantiate a SSMaterialCalendarPicker object on your View Controller:

```
#!Objective-C
// Add it on the keyWindow if you're using an UINavigationBar
datePicker = [SSMaterialCalendarPicker initCalendarOn:[UIApplication sharedApplication].keyWindow withDelegate:self];

// If there's a fullscreen view, add it there
datePicker = [SSMaterialCalendarPicker initCalendarOn:self.view withDelegate:self];
```

* Customize it as you wish:

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

* Show the calendar:

```
#!Objective-C
[datePicker showAnimated];
```

* Oh, and remember to implement the SSMaterialCalendarPickerDelegate **protocol**:

```
#!Objective-C
// .h code:
#import "SSMaterialCalendarPicker.h"
@interface ExampleViewController : UIViewController <SSMaterialCalendarPickerDelegate>

// .m code:
- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [formatter setDateFormat:@"EEEE, dd 'de' MMMM 'de' YYYY"];
    [self.startDateLabel setText:[NSString stringWithFormat:@"Entrada: %@", [formatter stringFromDate:startDate]]];
    [self.endDateLabel setText:[NSString stringWithFormat:@"Saída: %@", [formatter stringFromDate:endDate]]];
}
```

##Contact & Feedback##
If you have any feedbacks, doubts or you just want to yell at me for some reason, please send me an e-mail to [iurichiba@gmail.com](mailto:iurichiba@gmail.com). Any help on this project is more than welcome!

And if you end up using this component, I'd love to hear about your app and check it out! 🐶

###License###
> The MIT License
> 
> Copyright (c) 2015 Shoryuken Solutions ([iurichiba@gmail.com](mailto:iurichiba@gmail.com))
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
> 
