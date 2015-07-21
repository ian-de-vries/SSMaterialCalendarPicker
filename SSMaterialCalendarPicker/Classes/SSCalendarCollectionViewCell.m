//
//  SSCalendarCollectionViewCell.m
//
//
//  Created by Iuri Chiba on 7/16/15.
//
//

#import "SSCalendarCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultRippleColor [UIColor colorWithWhite:1.0f alpha:0.45f]
#define kDefaultSelectedColor [UIColor colorWithRed:223/255.0f green:116/255.0f blue:92/255.0f alpha:1.0f]

@implementation SSCalendarCollectionViewCell

#pragma mark - Initialization
- (void)calendarCellSetup {
    [self clearSubviews];
    [self setupRippleButton];
    [self setupSelectionIndicator];
}

- (void)clearSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark Visual Elements Initialization
- (void)setupRippleButton {
    CGFloat size = CGRectGetWidth(self.frame) * 0.8f;
    CGFloat x = (CGRectGetWidth(self.frame) * 0.2f)/2;
    CGFloat y = (CGRectGetWidth(self.frame) * 0.2f)/2;
    CGRect buttonFrame = CGRectMake(x, y, size, size);
    
    if (self.cellDate == nil) self.cellDate = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday
                                    fromDate:self.cellDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [formatter setDateFormat:@"EEEE"];
    NSString *weekday = [formatter stringFromDate:self.cellDate];
    
    self.innerButton = [[SSRippleButton alloc] initWithFrame:buttonFrame];
    [self.innerButton setTitle:[NSString stringWithFormat:@"%02d", (int) components.day] forState:UIControlStateNormal];
    if (self.headerMode) [self.innerButton setTitle:[weekday substringToIndex:1] forState:UIControlStateNormal];
    [self.innerButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.innerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.innerButton setDelegate:self];
    [self addSubview:self.innerButton];
}

- (void)setupSelectionIndicator {
    self.selectionIndicator = [[UIView alloc] initWithFrame:self.innerButton.frame];
    self.selectionIndicator.backgroundColor = [UIColor orangeColor];
    self.selectionIndicator.layer.cornerRadius = CGRectGetWidth(self.selectionIndicator.frame)/2;
    
    [self addSubview:self.selectionIndicator];
    [self sendSubviewToBack:self.selectionIndicator];
    
    self.selectionIndicator.alpha = 0.0f;
}

#pragma mark - Hit Extensor
- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) return self.innerButton;
    return [super hitTest:point withEvent:event];
}

#pragma mark - SSRippleButton Delegate
- (void)buttonClicked {
    if (self.delegate != nil)
        [self.delegate cellClicked:self];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [UIView animateWithDuration:0.3f animations:^{
        self.selectionIndicator.alpha = selected?1.0f:0.0f;
        [self.innerButton setTitleColor:selected?[UIColor whiteColor]:[UIColor blackColor]
                               forState:UIControlStateNormal];
    }];
}

@end

@implementation SSRippleButton {
    BOOL alternative;
}

#pragma mark - Initialization
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
    
    [UIView animateWithDuration:0.1f animations:^{
        self.rippleBackgroundView.alpha = 1.0f;
    }];
    
    self.rippleView.transform = CGAffineTransformMakeScale(alternative?0.1f:0.5f, alternative?0.1f:0.5f);
    
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
    [UIView animateWithDuration:0.1f animations:^{
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
