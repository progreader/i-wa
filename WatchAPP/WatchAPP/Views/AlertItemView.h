//
//  AlertItemView.h
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertItemViewmDelegate <NSObject>

- (void)alertItemWithId:(int)sid;

@end

@interface AlertItemView : UIView<UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) id<AlertItemViewmDelegate> delegate;

@end
