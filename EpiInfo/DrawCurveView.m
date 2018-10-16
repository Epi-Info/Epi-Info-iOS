//
//  DrawCurveView.m
//  EpiInfo
//
//  Created by labuser on 3/12/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "DrawCurveView.h"

@implementation DrawCurveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOriginAndColor:(float)x OriginY:(float)y Color:(UIColor *)color
{
    CGRect frame = CGRectMake(x, y - 100.0, [self frame].size.width, 100.0);
    self = [super initWithFrame:frame];
    [self setBackgroundColor:color];
    return self;
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
