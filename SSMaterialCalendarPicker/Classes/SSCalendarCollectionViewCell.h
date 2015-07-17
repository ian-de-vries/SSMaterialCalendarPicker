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

@interface SSCalendarCollectionViewCell : UICollectionViewCell <SSRippleButtonDelegate>

@property (strong, nonatomic) id<SSCalendarCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) SSRippleButton *button;
@property (strong, nonatomic) UIView *selectionIndicator;

@end

@interface SSRippleButton : UIButton

#pragma mark - Delegate
@property (strong, nonatomic) id<SSRippleButtonDelegate> delegate;

#pragma mark - Ripple
@property (strong, nonatomic) UIView *rippleBackgroundView;
@property (strong, nonatomic) UIView *rippleView;

@end