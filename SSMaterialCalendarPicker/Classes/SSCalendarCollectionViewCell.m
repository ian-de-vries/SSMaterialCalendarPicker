//
//  SSCalendarCollectionViewCell.m
//
//
//  Created by Iuri Chiba on 7/16/15.
//
//

#import "SSCalendarCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "NSDate+SSDateAdditions.h"
#import "UIImage+THColorInverter.h"

#define kDefaultRippleColor [UIColor colorWithWhite:1.0f alpha:0.45f]
#define kDefaultSelectedColor [UIColor orangeColor]

#pragma mark -
#pragma mark -
@implementation SSCalendarCollectionViewCell

#pragma mark - Initialization
- (void)calendarCellSetup {
    [self setupRippleButton];
    [self setupSelectionIndicator];
}

- (void)clearSubviews {
    for (UIView *subview in self.subviews)
        [subview removeFromSuperview];
}

#pragma mark Visual Elements Initialization
- (void)setupRippleButton {
    if (self.cellDate == nil) self.cellDate = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitDay | NSCalendarUnitMonth |
                                    NSCalendarUnitYear | NSCalendarUnitWeekday
                                    fromDate:self.cellDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.forceLocale != nil) [formatter setLocale:self.forceLocale];
    
    if (self.dayLabel == nil) {
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.dayLabel];
        [self.dayLabel setNumberOfLines:2];
        [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
        [self.dayLabel setFont:[UIFont systemFontOfSize:13.0f]];
    } [self.dayLabel setText:[NSString stringWithFormat:@"%02d", (int) components.day]];
    
    if (self.innerButton == nil) {
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat size =  width * 0.8f;
        CGFloat x = (width * 0.2f)/2;
        CGFloat y = (width * 0.2f)/2;
        CGRect buttonFrame = CGRectMake(x, y, size, size);
        self.innerButton = [[SSRippleButton alloc] initWithFrame:buttonFrame];
        [self addSubview:self.innerButton];
        [self.innerButton setDelegate:self];
    }
    
    if (self.headerMode || [self.cellDate.defaultTime compare:[NSDate date].defaultTime] == NSOrderedSame)
        [self.dayLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    else [self.dayLabel setFont:[UIFont systemFontOfSize:13.0f]];
    
    if (components.day == 1 && !self.headerMode) {
        [formatter setDateFormat:@"MMM"]; NSString *month = [formatter stringFromDate:self.cellDate].capitalizedString;
        NSString *title = [NSString stringWithFormat:@"%02d\n%@", (int) components.day, month];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, 2)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:8] range:NSMakeRange(3, 3)];
        [self.dayLabel setAttributedText:attrString];
    }
    
    if (self.headerMode) {
        [formatter setDateFormat:@"EEE"]; NSString *weekday = [formatter stringFromDate:self.cellDate].capitalizedString;
        [self.dayLabel setText:weekday];
    }
}

- (void)setupSelectionIndicator {
    if (self.selectionIndicator == nil) {
        self.selectionIndicator = [[UIView alloc] initWithFrame:self.innerButton.frame];
        self.selectionIndicator.backgroundColor = self.primaryColor == nil? kDefaultSelectedColor:self.primaryColor;
        self.selectionIndicator.layer.cornerRadius = CGRectGetWidth(self.selectionIndicator.frame)/2;
        if (self.lighterRadius) self.selectionIndicator.layer.cornerRadius = 4.0f;
        self.selectionIndicator.alpha = 0.0f;
        
        [self addSubview:self.selectionIndicator];
        [self sendSubviewToBack:self.selectionIndicator];
    }
}

#pragma mark - SSRippleButton Delegate
- (void)buttonClicked {
    if (self.delegate != nil)
        [self.delegate cellClicked:self];
}

#pragma mark - Hit Extensor
- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) return self.innerButton;
    return [super hitTest:point withEvent:event];
}

#pragma mark - Status Control
- (void)selectCalendarCell:(BOOL)selected {
    [self setSelected:selected];
    [UIView animateWithDuration:0.3f animations:^{
        [self.selectionIndicator setAlpha:selected?1.0f:0.0f];
        [self changeTitleColor:selected];
    }];
}

- (void)changeTitleColor:(BOOL)selected {
    [self.selectionIndicator setAlpha:selected?1.0f:0.0f];
    if ([self.dayLabel attributedText] == nil)
        [self.dayLabel setTextColor:selected?[UIColor whiteColor]:[UIColor blackColor]];
    else {
        NSMutableAttributedString *attrString = [[self.dayLabel attributedText] mutableCopy];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:selected?[UIColor whiteColor]:[UIColor blackColor]
                           range:NSMakeRange(0, attrString.length)];
        [self.dayLabel setAttributedText:attrString];
    }
}

- (void)fastSelectCalendarCell:(BOOL)selected {
    [self setSelected:selected];
    [self.selectionIndicator setAlpha:selected?1.0f:0.0f];
    [self changeTitleColor:selected];
}

- (void)disableCalendarCell:(BOOL)disabled {
    if (!self.headerMode) {
        [self setIsDisabled:disabled];
        if (disabled) [self selectCalendarCell:NO];
        [self setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [self setAlpha:disabled?0.2f:1.0f];
        }];
    }
}

- (void)fastDisableCalendarCell:(BOOL)disabled {
    if (!self.headerMode) {
        [self setIsDisabled:disabled];
        if (disabled) [self selectCalendarCell:NO];
        [self setUserInteractionEnabled:NO];
    }
}

- (void)blink {
    [UIView animateWithDuration:0.6f animations:^{
        self.dayLabel.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.dayLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }];
}

@end

@implementation SSRippleButton {
    BOOL alternative;
    UIImage *image;
}

#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupRipple];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:CGRectGetWidth(self.frame)/2];
        [self setClipsToBounds:YES];
    } return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRipple];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setCornerRadius:CGRectGetWidth(self.frame)/2];
        [self setClipsToBounds:YES];
    } return self;
}

- (void)setupRipple {
    alternative = YES;
    image = self.imageView.image;
    [self setupRippleView];
    [self setupRippleBackgroundView];
}

#pragma mark Ripple View Initialization
- (void)setupRippleView {
    if (self.rippleView == nil) {
        CGFloat size = CGRectGetWidth(self.frame) * (alternative?3.0f:0.8f);
        CGFloat x = CGRectGetWidth(self.frame)/2 - size/2;
        CGFloat y = CGRectGetHeight(self.frame)/2 - size/2;
        CGFloat corner = size/2;
        
        self.rippleView = [[UIView alloc] init];
        self.rippleView.backgroundColor = kDefaultRippleColor;
        self.rippleView.frame = CGRectMake(x, y, size, size);
        self.rippleView.layer.cornerRadius = corner;
    }
}

#pragma mark Ripple Background View Initialization
- (void)setupRippleBackgroundView {
    if (self.rippleBackgroundView == nil) {
        CGFloat size = CGRectGetWidth(self.frame);
        
        self.rippleBackgroundView = [[UIView alloc] init];
        self.rippleBackgroundView.backgroundColor = kDefaultRippleColor;
        self.rippleBackgroundView.frame = CGRectMake(0.0f, 0.0f, size, size);
        self.rippleBackgroundView.layer.cornerRadius = CGRectGetWidth(self.rippleBackgroundView.frame)/2;
        [self.layer addSublayer:self.rippleBackgroundView.layer];
        [self.rippleBackgroundView.layer addSublayer:self.rippleView.layer];
        [self.rippleBackgroundView setAlpha:0.0f];
    }
}

#pragma mark - Animation/Action Tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.rippleView.center = [touch locationInView:self];
    if (self.shouldChangeColorOnClick) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (image != nil) [self.imageView setImage:image.negativeImage];
    } [UIView animateWithDuration:0.1f animations:^{
        self.rippleBackgroundView.alpha = 1.0f;
    }]; self.rippleView.transform = CGAffineTransformMakeScale(alternative?0.1f:0.5f, alternative?0.1f:0.5f);
    [UIView animateWithDuration:alternative?1.0f:0.7f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.rippleView.transform = CGAffineTransformIdentity;
    } completion:nil];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self animateToNormal];
    if (self.delegate != nil)
        [self.delegate buttonClicked];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self animateToNormal];
    if (self.delegate != nil)
        [self.delegate buttonClicked];
}

- (void)animateToNormal {
    if (self.shouldChangeColorOnClick) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (image != nil) self.imageView.image = image;
    } [UIView animateWithDuration:0.1f animations:^{
        self.rippleBackgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6f animations:^{
            self.rippleBackgroundView.alpha = 0.0f;
        }];
    }];
    
    [UIView animateWithDuration:0.7f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut |
     UIViewAnimationOptionBeginFromCurrentState animations:^{
         self.rippleView.transform = CGAffineTransformIdentity;
     } completion:nil];
}

@end
