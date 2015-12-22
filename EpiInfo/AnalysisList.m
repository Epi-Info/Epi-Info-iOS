//
//  AnalysisList.m
//  EpiInfo
//
//  Created by John Copeland on 8/5/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "AnalysisList.h"

@implementation AnalysisList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        for (UIView *v in self.subviews)
        {
            [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, frame.size.width, v.frame.size.height)];
            for (UIView *sv in v.subviews)
                [sv setFrame:CGRectMake(sv.frame.origin.x, sv.frame.origin.y, v.frame.size.width, sv.frame.size.height)];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    for (UIView *v in self.subviews)
    {
        [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, frame.size.width, v.frame.size.height)];
        for (UIView *sv in v.subviews)
            [sv setFrame:CGRectMake(sv.frame.origin.x, sv.frame.origin.y, v.frame.size.width, sv.frame.size.height)];
    }
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
