//
//  IQTestPageControl.h
//  LadyMask
//
//  Created by mac  on 12-12-22.
//  Copyright (c) 2012年 fairzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPointPageControl : UIPageControl{
    // 表示正常与高亮状态的图片
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame;
- (void)updateDots;

@end
