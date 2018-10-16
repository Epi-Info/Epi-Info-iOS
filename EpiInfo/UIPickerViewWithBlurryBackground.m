//
//  UIPickerViewWithBlurryBackground.m
//  EpiInfo
//
//  Created by John Copeland on 6/9/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "UIPickerViewWithBlurryBackground.h"

@implementation UIPickerViewWithBlurryBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    gestureRecognizer.delegate = self;
    [super addGestureRecognizer:gestureRecognizer];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview || blurryBackground)
        return;
    
    blurryBackground = [[BlurryView alloc] initWithFrame:self.frame];
    [blurryBackground.layer setCornerRadius:8.0];
    [newSuperview addSubview:blurryBackground];
}

- (void)didMoveToSuperview
{
    if (![self superview])
        return;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (blurryBackground)
        [blurryBackground setFrame:frame];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if (blurryBackground)
        [blurryBackground removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [blurryBackground setHidden:hidden];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
