//
//  IQTestPageControl.m
//  LadyMask
//
//  Created by mac  on 12-12-22.
//  Copyright (c) 2012年 fairzy. All rights reserved.
//

#import "RedPointPageControl.h"


@implementation RedPointPageControl

@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imagePageStateNormal = [UIImage imageNamed:@"pagecontrol_gray_point.png"];
        self.imagePageStateHighlighted = [UIImage imageNamed:@"pagecontrol_red_point.png"];
    }
    return self;
}

// 捕捉点击事件
- (void)endTrackingWithTouch : (UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

// 更新显示所有的点按钮
- (void)updateDots
{
    if(imagePageStateNormal && imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for(NSInteger i =0; i<[subview count]; i++)
        {
            if ([subview isKindOfClass:[UIImageView class]]) {
                UIImageView *dot = [subview objectAtIndex:i];
                
                dot.image = (self.currentPage == i ? imagePageStateHighlighted : imagePageStateNormal);
            }

        }
    }
}

- (void)dealloc
{
    [imagePageStateNormal release];
    [imagePageStateHighlighted release];
    [super dealloc];
}

@end
