//
//  ClickingView.m
//  EpiInfo
//
//  Created by John Copeland on 12/24/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "ClickingView.h"

@implementation ClickingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
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
