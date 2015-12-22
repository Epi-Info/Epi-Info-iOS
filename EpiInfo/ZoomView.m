//
//  ZoomView.m
//  EpiInfo
//
//  Created by John Copeland on 5/21/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "ZoomView.h"

@implementation ZoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    //Overriding sizeThatFits to actually compute what size fits the subviews
    float maxWidth = size.width;
    float maxHeight = size.height;
    for (UIView *view in self.subviews)
    {
        if (view.frame.origin.x + view.frame.size.width > maxWidth)
            maxWidth = view.frame.origin.x + view.frame.size.width;
        if (view.frame.origin.y + view.frame.size.height > maxHeight)
            maxHeight = view.frame.origin.y + view.frame.size.height;
    }
    return CGSizeMake(maxWidth, maxHeight);
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
