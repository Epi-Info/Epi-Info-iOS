//
//  GroupOfVariablesInputs.m
//  EpiInfo
//
//  Created by John Copeland on 11/15/19.
//

#import "GroupOfVariablesInputs.h"

@implementation GroupOfVariablesInputs

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
        }completion:nil];
    }
    return self;
}

- (void)removeSelf:(UIButton *)sender
{
    [super removeSelf:sender];
    if ([[[sender titleLabel] text] isEqualToString:@"Save"])
    {
    }
    else
    {
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
