//
//  CommandButton.m
//  EpiInfo
//
//  Created by John Copeland on 9/9/19.
//

#import "CommandButton.h"
#import "EnterDataView.h"

@implementation CommandButton

- (id)initWithFrame:(CGRect)frame AndPromptText:(nonnull NSString *)prompt
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float newWidth = 6.0 * self.frame.size.width;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height)];
        [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, newWidth - 2.0, button.frame.size.height)];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [button setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [button setTitle:prompt forState:UIControlStateNormal];
    }
    return self;
}

- (void)buttonPressed
{
    if ([[[self superview] superview] isKindOfClass:[EnterDataView class]])
        [(EnterDataView *)[[self superview] superview] fieldResignedFirstResponder:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
