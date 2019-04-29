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
        
        self.beforeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 2.0, 32)];
        [self.beforeButton setBackgroundColor:[UIColor whiteColor]];
        [self.beforeButton setTitle:@"Before" forState:UIControlStateNormal];
        [self.beforeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self.beforeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.beforeButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.beforeButton];
        
        self.afterButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 0, frame.size.width / 2.0, 32)];
        [self.afterButton setBackgroundColor:[UIColor whiteColor]];
        [self.afterButton setTitle:@"After" forState:UIControlStateNormal];
        [self.afterButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [self.afterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [self.afterButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.afterButton];
        
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 2.0, 32)];
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.height > 0.0)
    {
        [self.beforeButton setFrame:CGRectMake(0, 2, frame.size.width / 2.0, 32)];
        [self.afterButton setFrame:CGRectMake(frame.size.width / 2.0, 2, frame.size.width / 2.0, 32)];
        [self.closeButton setFrame:CGRectMake(0, frame.size.height - 48.0, frame.size.width / 2.0, 32)];
    }
    else
    {
        [self.beforeButton setFrame:CGRectMake(0, 0, frame.size.width / 2.0, 32)];
        [self.afterButton setFrame:CGRectMake(frame.size.width / 2.0, 0, frame.size.width / 2.0, 32)];
        [self.closeButton setFrame:CGRectMake(0, 0, frame.size.width / 2.0, 32)];
    }
}

- (void)beforeOrAfterButtonPressed:(UIButton *)sender
{
    if ([[[sender titleLabel] text] isEqualToString:@"After"])
    {
        NSLog(@"After button pressed");
    }
    else
    {
        NSLog(@"Before button pressed");
    }
}

- (void)closeButtonPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:CGRectMake(1, 1, self.frame.size.width, 0)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
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
