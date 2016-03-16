//
//  SSCalendarCollectionViewCell.h
//
//
//  Created by Iuri Chiba on 7/16/15.
//
//

#import <UIKit/UIKit.h>

@class SSCalendarCollectionViewCell;
@class SSRippleButton;

#pragma mark - Protocols
@protocol SSCalendarCollectionViewCellDelegate <NSObject>

- (void)cellClicked:(SSCalendarCollectionViewCell *)cell;

@end

@protocol SSRippleButtonDelegate <NSObject>

- (void)buttonClicked;

@end

#pragma mark - Classes
#pragma mark - Calendar Cell
@interface SSCalendarCollectionViewCell : UICollectionViewCell <SSRippleButtonDelegate>

#pragma mark Customization:
@property (strong, nonatomic) NSLocale *forceLocale;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) UIColor *secondaryColor;
@property (nonatomic) BOOL lighterRadius;

#pragma mark Interaction Properties:
@property (strong, nonatomic) id<SSCalendarCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) NSDate *cellDate;

#pragma mark Visual Cues:
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) SSRippleButton *innerButton;
@property (strong, nonatomic) UIView *selectionIndicator;

#pragma mark Modes:
@property (nonatomic) BOOL isDisabled;
@property (nonatomic) BOOL headerMode;

#pragma mark Interaction & Effects
- (void)selectCalendarCell:(BOOL)selected;
- (void)fastSelectCalendarCell:(BOOL)selected;
- (void)disableCalendarCell:(BOOL)disabled;
- (void)fastDisableCalendarCell:(BOOL)disabled;
- (void)calendarCellSetup;
- (void)blink;

@end

#pragma mark - Ripple Button
@interface SSRippleButton : UIButton

@property (nonatomic) IBInspectable BOOL shouldChangeColorOnClick;

#pragma mark Interaction Properties:
@property (strong, nonatomic) id<SSRippleButtonDelegate> delegate;

#pragma mark Ripple Effect:
@property (strong, nonatomic) UIView *rippleBackgroundView;
@property (strong, nonatomic) UIView *rippleView;

@end