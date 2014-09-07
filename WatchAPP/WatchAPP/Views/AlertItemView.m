//
//  AlertItemView.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "AlertItemView.h"

@implementation AlertItemView

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)viewClick:(id)sender
{
    if (delegate) {
        [delegate alertItemWithId:self.tag];
    }
}

@end
