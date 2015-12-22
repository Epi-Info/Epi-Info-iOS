//
//  ButtonLeft.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "ButtonLeft.h"

@implementation ButtonLeft

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:@"ArrowLeft.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ArrowFull.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndSlider:(UISlider *)s
{
    self = [self initWithFrame:frame];
    if (self)
    {
        slider = s;
        [self addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonPressed
{
    if ([slider value] == [slider minimumValue])
    {
        return;
    }
    [slider setValue:round(10 * ([slider value] - 0.1)) / 10 animated:YES];
    [slider sendActionsForControlEvents:UIControlEventValueChanged];
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
