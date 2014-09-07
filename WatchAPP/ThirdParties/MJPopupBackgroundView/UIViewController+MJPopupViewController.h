//
//  UIViewController+MJPopupViewController.h
//  MJModalViewController
//
//  Created by Martin Juhasz on 11.05.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPopupBackgroundView;

typedef enum {
    MJPopupViewAnimationFade = 0,
    MJPopupViewAnimationSlideBottomTop = 1,
    MJPopupViewAnimationSlideBottomBottom,
    MJPopupViewAnimationSlideTopTop,
    MJPopupViewAnimationSlideTopBottom,
    MJPopupViewAnimationSlideLeftLeft,
    MJPopupViewAnimationSlideLeftRight,
    MJPopupViewAnimationSlideRightLeft,
    MJPopupViewAnimationSlideRightRight,
    MJPopupViewAnimationZoomInOut
} MJPopupViewAnimation;

@interface UIViewController (MJPopupViewController)

@property (nonatomic, retain) UIViewController *mj_popupViewController;
@property (nonatomic, retain) MJPopupBackgroundView *mj_popupBackgroundView;
@property (nonatomic, retain) UIButton *mj_dismissButton;
@property (nonatomic, retain) id mj_dismissDelegate;

- (void)presentPopupViewController:(UIViewController *)popupViewController animationType:(MJPopupViewAnimation)animationType whiteOverlayAlpha:(float)whiteOverlayAlpha isBackgroundClickable:(BOOL)isBackgroundClickable;
- (void)presentPopupViewController:(UIViewController *)popupViewController animationType:(MJPopupViewAnimation)animationType whiteOverlayAlpha:(float)whiteOverlayAlpha isBackgroundClickable:(BOOL)isBackgroundClickable dismissed:(void(^)(void))dismissed;
- (void)presentPopupViewController:(UIViewController *)popupViewController animationType:(MJPopupViewAnimation)animationType isBackgroundClickable:(BOOL)isBackgroundClickable;
- (void)presentPopupViewController:(UIViewController *)popupViewController animationType:(MJPopupViewAnimation)animationType isBackgroundClickable:(BOOL)isBackgroundClickable dismissed:(void(^)(void))dismissed;
- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType;
- (IBAction)closePopView:(id)sender;

@end

@protocol MJPopupCloseDelegate<NSObject>

@optional
- (void)dismiss:(id)sender;

@end
