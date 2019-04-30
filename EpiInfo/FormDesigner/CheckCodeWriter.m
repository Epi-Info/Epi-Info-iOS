//
//  CheckCodeWriter.m
//  EpiInfo
//
//  Created by John Copeland on 4/29/19.
//

#import "CheckCodeWriter.h"

@implementation CheckCodeWriter
@synthesize beforeButton = _beforeButton;
@synthesize afterButton = _afterButton;
@synthesize closeButton = _closeButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.beforeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, frame.size.width / 2.0, 32)];
        [self.beforeButton setBackgroundColor:[UIColor whiteColor]];
        [self.beforeButton setTitle:@"Before" forState:UIControlStateNormal];
        [self.beforeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self.beforeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.beforeButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.beforeButton setEnabled:NO];
        [self addSubview:self.beforeButton];
        
        self.afterButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 2, frame.size.width / 2.0, 32)];
        [self.afterButton setBackgroundColor:[UIColor whiteColor]];
        [self.afterButton setTitle:@"After" forState:UIControlStateNormal];
        [self.afterButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self.afterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.afterButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.afterButton];
        
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - 48.0, frame.size.width / 2.0, 32)];
        [self.closeButton setBackgroundColor:[UIColor whiteColor]];
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self.closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)beforeOrAfterButtonPressed:(UIButton *)sender
{
    UIView *selectFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [selectFunctionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:selectFunctionView];
    if ([[[sender titleLabel] text] isEqualToString:@"After"])
    {
        if (YES)
        {
            UIButton *differenceInYearsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, selectFunctionView.frame.size.width / 2.0, 32)];
            [differenceInYearsButton setBackgroundColor:[UIColor whiteColor]];
            [differenceInYearsButton setTitle:@"Years" forState:UIControlStateNormal];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [differenceInYearsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [differenceInYearsButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [selectFunctionView addSubview:differenceInYearsButton];
            [selectFunctionView setTag:0];
        }
    }
    else
    {
        NSLog(@"Before button pressed");
    }
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, selectFunctionView.frame.size.height - 32, selectFunctionView.frame.size.width / 2.0, 32)];
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectFunctionView addSubview:closeButton];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [selectFunctionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)functionSelectionButtonPressed:(UIButton *)sender
{
    NSLog(@"%@", [[sender titleLabel] text]);
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
