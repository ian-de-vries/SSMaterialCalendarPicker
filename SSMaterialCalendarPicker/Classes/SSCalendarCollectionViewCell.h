//
//  SSCalendarCollectionViewCell.h
//  
//
//  Created by Iuri Chiba on 7/16/15.
//
//

#import <UIKit/UIKit.h>

@class SSRippleButton;

@interface SSCalendarCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) SSRippleButton *button;

@end

@interface SSRippleButton : UIButton

#pragma mark - Ripple
@property (strong, nonatomic) UIView *rippleBackgroundView;
@property (strong, nonatomic) UIView *rippleView;

@end